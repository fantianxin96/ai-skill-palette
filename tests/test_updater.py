import importlib.util, pathlib, tempfile, plistlib, unittest
spec=importlib.util.spec_from_file_location('updater',pathlib.Path(__file__).parents[1]/'Resources/updater.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
class Tests(unittest.TestCase):
 def test_url_refused(self):
  for url in ['http://api.github.com/x','https://evil.example/x','https://user:token@api.github.com/x','https://api.github.com/x?token=secret']:
   with self.assertRaises(ValueError):m.download(url)
 def test_idle_conflict_and_apply(self):
  with tempfile.TemporaryDirectory() as d:
   root=pathlib.Path(d).resolve();app=root/'App.app';(app/'Contents').mkdir(parents=True);(app/'Contents/Info.plist').write_bytes(plistlib.dumps({'CFBundleVersion':'118'}));state=root/'state'
   running=[True];u=m.Updater(app,state,runner=lambda *a,**k:None,running=lambda _:running[0]);stage=state/'staged.app';(stage/'Contents').mkdir(parents=True);(stage/'Contents/Info.plist').write_bytes(plistlib.dumps({'CFBundleVersion':'119'}))
   manifest=dict(stage=str(stage),current_build=118,target_build=119,commit='a'*40,base_fingerprint=m.fingerprint(app),staged_fingerprint=m.fingerprint(stage));u.write('manifest.json',manifest)
   self.assertFalse(u.apply());self.assertEqual(u.build(),118)
   running[0]=False;(app/'changed').write_text('local edit')
   with self.assertRaises(ValueError):u.apply()
   (app/'changed').unlink();self.assertTrue(u.apply());self.assertEqual(u.build(),119);self.assertTrue(u.read('receipt.json')['backup'])
 def test_symlink(self):
  with tempfile.TemporaryDirectory() as d:
   p=pathlib.Path(d);(p/'real').mkdir();(p/'alias').symlink_to(p/'real')
   with self.assertRaises(ValueError):m.fingerprint(p/'alias')
class FailureTests(unittest.TestCase):
 def fixture(self,root):
  app=root/'App.app';(app/'Contents/MacOS').mkdir(parents=True);(app/'Contents/MacOS/AISkillPalette').write_bytes(b'old');(app/'Contents/Info.plist').write_bytes(plistlib.dumps({'CFBundleVersion':'118','CFBundleIdentifier':'com.fantianxin.aiskillpalette'}))
  u=m.Updater(app,root/'state',runner=lambda *a,**k:None,running=lambda _:False)
  stage=u.state/'staged.app';m.shutil.copytree(app,stage);info=stage/'Contents/Info.plist';d=plistlib.loads(info.read_bytes());d['CFBundleVersion']='119';info.write_bytes(plistlib.dumps(d))
  u.write('manifest.json',dict(stage=str(stage),current_build=118,target_build=119,commit='a'*40,base_fingerprint=m.fingerprint(app),staged_fingerprint=m.fingerprint(stage),binary_sha256=m.digest(stage/'Contents/MacOS/AISkillPalette')))
  return u,stage
 def test_tamper_and_stale(self):
  with tempfile.TemporaryDirectory() as d:
   u,stage=self.fixture(pathlib.Path(d).resolve());(stage/'changed').write_text('tamper')
   with self.assertRaises(ValueError):u.apply()
   self.assertEqual(u.build(),118)
   (stage/'changed').unlink();manifest=u.read('manifest.json');manifest['target_build']=118;u.write('manifest.json',manifest)
   with self.assertRaises(m.Conflict):u.apply()
 def test_rename_rollback(self):
  from unittest.mock import patch
  with tempfile.TemporaryDirectory() as d:
   u,_=self.fixture(pathlib.Path(d).resolve());original=pathlib.Path.rename
   def rename(path,target):
    if path.name.startswith('.AI-Skill-Palette-update-'):raise OSError('injected rename failure')
    return original(path,target)
   with patch.object(pathlib.Path,'rename',rename):
    with self.assertRaises(OSError):u.apply()
   self.assertEqual(u.build(),118)
 def test_health_and_no_reinstall(self):
  with tempfile.TemporaryDirectory() as d:
   u,_=self.fixture(pathlib.Path(d).resolve());u.apply();r=u.read('receipt.json')
   u.write('health.json',dict(build='119',commit='bad',launched_at=r['installed_at']+1));u.finalize();self.assertTrue(u.read('manifest.json'))
   u.write('health.json',dict(build='119',commit=r['commit'],launched_at=r['installed_at']+1));u.finalize();self.assertFalse(u.read('manifest.json'));self.assertEqual(u.read('status.json')['phase'],'current')
 def test_busy(self):
  with tempfile.TemporaryDirectory() as d:
   u,_=self.fixture(pathlib.Path(d).resolve())
   with (u.state/'lock').open('a') as lock:
    m.fcntl.flock(lock,m.fcntl.LOCK_EX|m.fcntl.LOCK_NB);self.assertEqual(u.run('check')['phase'],'busy');self.assertFalse(u.read('status.json'))
 def test_compile_failure_preserves_app(self):
  with tempfile.TemporaryDirectory() as d:
   u,_=self.fixture(pathlib.Path(d).resolve());(u.state/'manifest.json').unlink()
   def http(url):
    if url.endswith('/commits/main'):return b'{"sha":"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"}'
    if url.endswith('build.sh'):return b'<key>CFBundleVersion</key><string>119</string>'
    return b'invalid source'
   def fail(*a,**k):raise RuntimeError('compiler failed')
   u.http=http;u.runner=fail
   with self.assertRaises(RuntimeError):u.run('check')
   self.assertEqual(u.build(),118);self.assertEqual(u.read('status.json')['phase'],'error')
class RecoveryTests(FailureTests):
 def transaction(self,u,stage):
  mfest=u.read('manifest.json');backups=u.state/'backups';backups.mkdir();backup=backups/('118-'+m.uuid.uuid4().hex+'.app');temp=u.target.with_name('.AI-Skill-Palette-update-'+m.uuid.uuid4().hex+'.app');m.shutil.copytree(stage,temp)
  tx=dict(backup=str(backup),temp=str(temp),old_fingerprint=mfest['base_fingerprint'],new_fingerprint=mfest['staged_fingerprint'],manifest=mfest,started_at=m.time.time());u.write('transaction.json',tx)
  return tx,backup,temp
 def test_target_missing_restores(self):
  with tempfile.TemporaryDirectory() as d:
   u,stage=self.fixture(pathlib.Path(d).resolve());tx,backup,temp=self.transaction(u,stage);u.target.rename(backup);u.recover();self.assertEqual(u.build(),118);self.assertFalse(u.read('transaction.json'))
 def test_installed_candidate_recovery(self):
  with tempfile.TemporaryDirectory() as d:
   u,stage=self.fixture(pathlib.Path(d).resolve());tx,backup,temp=self.transaction(u,stage);u.target.rename(backup);temp.rename(u.target);u.recover();self.assertEqual(u.build(),119);self.assertEqual(u.read('status.json')['phase'],'installed_pending_launch');self.assertTrue(u.read('receipt.json'))
 def test_invalid_backup_refused(self):
  with tempfile.TemporaryDirectory() as d:
   u,stage=self.fixture(pathlib.Path(d).resolve());tx,backup,temp=self.transaction(u,stage);u.target.rename(backup);(backup/'tampered').write_text('x')
   with self.assertRaises(m.Conflict):u.recover()
   self.assertFalse(u.target.exists());self.assertTrue(backup.exists())
 def test_crash_between_renames(self):
  from unittest.mock import patch
  with tempfile.TemporaryDirectory() as d:
   u,stage=self.fixture(pathlib.Path(d).resolve());original=pathlib.Path.rename
   def crash(path,target):
    value=original(path,target)
    if path==u.target:raise KeyboardInterrupt('simulated process death')
    return value
   with patch.object(pathlib.Path,'rename',crash):
    with self.assertRaises(KeyboardInterrupt):u.apply()
   self.assertFalse(u.target.exists());self.assertTrue(u.read('transaction.json'));u.recover();self.assertEqual(u.build(),118)
 def test_preflight_failure_no_ack(self):
  with tempfile.TemporaryDirectory() as d:
   u,stage=self.fixture(pathlib.Path(d).resolve());(stage/'tampered').write_text('x')
   with self.assertRaises(m.Conflict):u.run('apply-wait',request_id=str(m.uuid.uuid4()))
   self.assertFalse(u.read('apply-ready.json'));self.assertEqual(u.build(),118)
 def test_busy_no_ack(self):
  with tempfile.TemporaryDirectory() as d:
   u,stage=self.fixture(pathlib.Path(d).resolve())
   with (u.state/'lock').open('a') as lock:
    m.fcntl.flock(lock,m.fcntl.LOCK_EX|m.fcntl.LOCK_NB);self.assertEqual(u.run('apply-wait',request_id=str(m.uuid.uuid4()))['phase'],'busy');self.assertFalse(u.read('apply-ready.json'))
if __name__=='__main__':unittest.main()
