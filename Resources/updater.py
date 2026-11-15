#!/usr/bin/env python3
"""Fixed-repository updater. Never executes downloaded build or install scripts."""
import argparse, fcntl, hashlib, json, os, plistlib, re, shutil, subprocess, time, urllib.request, uuid
from pathlib import Path
REPO = 'fantianxin96/ai-skill-palette'
TARGET = Path('/Applications/AI Skill Palette.app')
STATE = Path.home() / 'Library/Application Support/AI Skill Palette/Updater'

class NoRedirect(urllib.request.HTTPRedirectHandler):

    def redirect_request(self, *args, **kwargs):
        raise ValueError('Redirect refused')

def download(url):
    from urllib.parse import urlsplit
    u = urlsplit(url)
    if u.scheme != 'https' or u.hostname not in ('api.github.com', 'raw.githubusercontent.com') or u.username or u.password or u.port or u.query or u.fragment:
        raise ValueError('Untrusted URL')
    req = urllib.request.Request(url, headers={'User-Agent': 'AI-Skill-Palette-Updater', 'Accept': 'application/vnd.github+json'})
    with urllib.request.build_opener(NoRedirect).open(req, timeout=30) as response:
        data = response.read(4000001)
    if len(data) > 4000000:
        raise ValueError('Oversized response')
    return data

def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()

def fingerprint(app):
    if app.is_symlink():
        raise ValueError('Symlink App refused')
    result = {}
    for p in sorted(app.rglob('*')):
        if p.is_symlink():
            raise ValueError('Symlink in App refused')
        if p.is_file():
            result[str(p.relative_to(app))] = digest(p)
    return result

def app_running(target):
    result = subprocess.run(['/bin/ps', '-ww', '-axo', 'comm='], capture_output=True, text=True, check=True)
    return str(target / 'Contents/MacOS/AISkillPalette') in {line.strip() for line in result.stdout.splitlines()}

class Conflict(ValueError):
    pass

class Updater:

    def __init__(self, target=TARGET, state=STATE, http=download, runner=subprocess.run, running=app_running):
        self.target = Path(target)
        self.state = Path(state)
        self.http = http
        self.runner = runner
        self.running = running
        for root in (self.target, self.state):
            if any((p.is_symlink() for p in (root, *root.parents))):
                raise ValueError('Symlink path refused')
        self.state.mkdir(parents=True, exist_ok=True, mode=448)
        os.chmod(self.state, 448)

    def read(self, name):
        p = self.state / name
        if p.is_symlink():
            raise ValueError('Symlink state refused')
        return json.loads(p.read_text()) if p.exists() else {}

    def write(self, name, value):
        p = self.state / (name + '.' + uuid.uuid4().hex + '.tmp')
        p.write_text(json.dumps(value, ensure_ascii=False, indent=2))
        os.chmod(p, 384)
        p.replace(self.state / name)

    def build(self):
        return int(plistlib.loads((self.target / 'Contents/Info.plist').read_bytes())['CFBundleVersion'])

    def status(self, phase, message, **kw):
        value = dict(phase=phase, message=message, current_build=self.build() if self.target.exists() else None, **kw)
        self.write('status.json', value)
        return value

    def command(self, args):
        self.runner(args, check=True, capture_output=True)

    def apply(self, reopen=False):
        m = self.read('manifest.json')
        if not m or self.running(self.target):
            return False
        if int(m.get('target_build', 0)) <= self.build():
            raise Conflict('Stale update refused')
        stage = Path(m['stage'])
        if stage.parent != self.state or stage.name != 'staged.app':
            raise ValueError('Invalid stage')
        if fingerprint(stage) != m['staged_fingerprint']:
            raise ValueError('Staged App changed')
        if fingerprint(self.target) != m['base_fingerprint']:
            raise Conflict('Installed App changed; refusing overwrite')
        if plistlib.loads((stage / 'Contents/Info.plist').read_bytes()).get('CFBundleIdentifier') != plistlib.loads((self.target / 'Contents/Info.plist').read_bytes()).get('CFBundleIdentifier'):
            raise Conflict('Bundle identifier changed')
        self.command(['/usr/bin/codesign', '--verify', '--deep', '--strict', str(stage)])
        backups = self.state / 'backups'
        backups.mkdir(exist_ok=True)
        backup = backups / (str(m['current_build']) + '-' + uuid.uuid4().hex + '.app')
        temp = self.target.with_name('.AI-Skill-Palette-update-' + uuid.uuid4().hex + '.app')
        shutil.copytree(stage, temp)
        if self.running(self.target):
            shutil.rmtree(temp)
            return False
        self.target.rename(backup)
        try:
            temp.rename(self.target)
        except BaseException:
            backup.rename(self.target)
            raise
        self.write('receipt.json', dict(m, backup=str(backup), installed_at=time.time()))
        self.status('installed_pending_launch', '更新已安装，等待下次启动验证', target_build=m['target_build'], commit=m['commit'])
        if reopen:
            self.command(['/usr/bin/open', '-g', str(self.target), '--args', '--background-update'])
        return True

    def finalize(self):
        health = self.read('health.json')
        receipt = self.read('receipt.json')
        if receipt and str(health.get('build')) == str(self.build()) and (health.get('commit') == receipt.get('commit')) and (float(health.get('launched_at', 0)) >= float(receipt.get('installed_at', float('inf')))) and (digest(self.target / 'Contents/MacOS/AISkillPalette') == receipt.get('binary_sha256')):
            if (self.state / 'manifest.json').exists():
                (self.state / 'manifest.json').unlink()
            return self.status('current', '更新启动验证通过', commit=receipt['commit'])
        return self.read('status.json')

    def check(self):
        self.finalize()
        manifest = self.read('manifest.json')
        if manifest:
            if int(manifest.get('target_build', 0)) == self.build():
                return self.read('status.json')
            if self.apply():
                return self.read('status.json')
            return self.status('ready', '更新已准备，退出 App 后安全生效', **{k: v for k, v in manifest.items() if k in ('target_build', 'commit')})
        self.status('checking', '正在检查 GitHub 更新')
        commit = json.loads(self.http('https://api.github.com/repos/' + REPO + '/commits/main'))['sha']
        if not re.fullmatch('[0-9a-f]{40}', commit):
            raise ValueError('Invalid commit')
        raw = 'https://raw.githubusercontent.com/' + REPO + '/' + commit + '/'
        script = self.http(raw + 'build.sh').decode()
        version = re.search('<key>CFBundleVersion</key>\\s*<string>([0-9]+)</string>', script)
        if not version:
            raise ValueError('Missing version')
        version = int(version[1])
        current = self.build()
        if version <= current:
            receipt = self.read('receipt.json')
            if version == current and receipt.get('target_build') == current:
                source = self.http(raw + 'Sources/GlobalSkillPalette.swift')
                helper = self.http(raw + 'Resources/updater.py')
                if hashlib.sha256(source).hexdigest() != receipt.get('source_sha256') or hashlib.sha256(helper).hexdigest() != receipt.get('helper_sha256'):
                    return self.status('version_not_bumped', '同版本代码变化，拒绝自动替换', target_build=version, commit=commit)
            return self.status('current', '已是最新版本', target_build=version, commit=commit)
        base = fingerprint(self.target)
        source = self.http(raw + 'Sources/GlobalSkillPalette.swift')
        helper = self.http(raw + 'Resources/updater.py')
        icon = self.http(raw + 'Assets/AppIcon.icns')
        stage = self.state / 'staged.app'
        if stage.exists():
            shutil.rmtree(stage)
        shutil.copytree(self.target, stage)
        src = self.state / 'update.swift'
        src.write_bytes(source)
        self.status('building', '正在后台构建更新', target_build=version, commit=commit)
        self.command(['/usr/bin/xcrun', 'swiftc', '-module-cache-path', str(self.state / 'module-cache'), str(src), '-framework', 'Cocoa', '-framework', 'Carbon', '-o', str(stage / 'Contents/MacOS/AISkillPalette')])
        info = stage / 'Contents/Info.plist'
        pl = plistlib.loads(info.read_bytes())
        pl['CFBundleVersion'] = str(version)
        info.write_bytes(plistlib.dumps(pl))
        resources = stage / 'Contents/Resources'
        resources.mkdir(exist_ok=True)
        (resources / 'updater.py').write_bytes(helper)
        (resources / 'AppIcon.icns').write_bytes(icon)
        self.command(['/usr/bin/codesign', '--force', '--sign', '-', str(stage)])
        self.command(['/usr/bin/codesign', '--verify', '--deep', '--strict', str(stage)])
        self.write('manifest.json', dict(stage=str(stage), commit=commit, current_build=current, target_build=version, base_fingerprint=base, staged_fingerprint=fingerprint(stage), source_sha256=hashlib.sha256(source).hexdigest(), helper_sha256=hashlib.sha256(helper).hexdigest(), icon_sha256=hashlib.sha256(icon).hexdigest(), binary_sha256=digest(stage / 'Contents/MacOS/AISkillPalette')))
        if not self.apply():
            return self.status('ready', '更新已准备，退出 App 后安全生效', target_build=version, commit=commit)
        return self.read('status.json')

    def run(self, action, reopen=False):
        if (self.state / 'lock').is_symlink():
            raise ValueError('Symlink lock refused')
        with (self.state / 'lock').open('a') as lock:
            os.chmod(self.state / 'lock', 384)
            try:
                fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
            except BlockingIOError:
                return dict(phase='busy', message='另一个更新任务正在运行')
            try:
                if action == 'check':
                    return self.check()
                if action == 'status':
                    return self.read('status.json')
                if action == 'finalize':
                    return self.finalize()
                if action == 'apply-wait':
                    deadline = time.time() + 60
                    while self.running(self.target) and time.time() < deadline:
                        time.sleep(1)
                return self.apply(reopen=reopen)
            except Exception as exc:
                self.write('error.json', dict(time=time.time(), error=str(exc)))
                self.status('conflict' if isinstance(exc, Conflict) else 'error', str(exc))
                raise
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('action', choices=['check', 'status', 'apply-if-idle', 'apply-wait', 'finalize'])
    parser.add_argument('--reopen', action='store_true')
    args = parser.parse_args()
    print(json.dumps(Updater().run(args.action, args.reopen), ensure_ascii=False))
