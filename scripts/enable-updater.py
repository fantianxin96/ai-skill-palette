#!/usr/bin/env python3
"""Enable/disable the user-level updater without modifying App, Skills or Git state."""
import argparse
import os
from pathlib import Path
import plistlib
import shutil
import subprocess

LABEL = "com.fantianxin.aiskillpalette.updater"
TARGET = Path("/Applications/AI Skill Palette.app")
STATE = Path.home() / "Library/Application Support/AI Skill Palette/Updater"
PLIST = Path.home() / "Library/LaunchAgents" / (LABEL + ".plist")

def enable(disable=False):
    if os.geteuid() == 0:
        raise RuntimeError("Run as the normal user, never sudo")
    for path in (STATE, PLIST, TARGET):
        if any(item.is_symlink() for item in (path, *path.parents)):
            raise RuntimeError("Symlink paths are not supported")
    if disable:
        if PLIST.exists():
            subprocess.run(["/bin/launchctl", "bootout", "gui/" + str(os.getuid()), str(PLIST)], check=False)
            PLIST.rename(PLIST.with_suffix(".plist.disabled"))
        print("Background updater disabled; App, data and backups preserved.")
        return
    if not TARGET.is_dir() or TARGET.stat().st_uid != os.getuid():
        raise RuntimeError("App must already be installed and owned by the current user; no privilege escalation")
    helper = Path(__file__).resolve().parents[1] / "Resources/updater.py"
    if not helper.is_file():
        raise RuntimeError("Missing reviewed updater helper")
    STATE.mkdir(parents=True, exist_ok=True, mode=0o700)
    STATE.chmod(0o700)
    PLIST.parent.mkdir(parents=True, exist_ok=True)
    bootstrap = STATE / "bootstrap.py"
    if PLIST.exists():
        expected = ["/usr/bin/python3", str(bootstrap), "check"]
        existing = plistlib.loads(PLIST.read_bytes())
        if existing.get("Label") != LABEL or existing.get("ProgramArguments") != expected:
            raise RuntimeError("Conflicting existing updater configuration; refusing overwrite")
        raise RuntimeError("Updater already enabled; preserve existing job and review changes separately")
    temporary = STATE / "bootstrap.py.new"
    if temporary.exists() or bootstrap.exists():
        raise RuntimeError("Existing bootstrap found; review before replacing")
    shutil.copyfile(helper, temporary)
    temporary.chmod(0o600)
    temporary.replace(bootstrap)
    job = {"Label": LABEL, "ProgramArguments": ["/usr/bin/python3", str(bootstrap), "check"],
           "RunAtLoad": True, "StartInterval": 3600, "ProcessType": "Background", "LowPriorityIO": True, "Nice": 10,
           "EnvironmentVariables": {"PATH": "/usr/bin:/bin:/usr/sbin:/sbin", "LANG": "en_US.UTF-8"},
           "StandardOutPath": str(STATE / "worker.log"), "StandardErrorPath": str(STATE / "worker-error.log")}
    PLIST.write_bytes(plistlib.dumps(job))
    PLIST.chmod(0o600)
    try:
        subprocess.run(["/bin/launchctl", "bootstrap", "gui/" + str(os.getuid()), str(PLIST)], check=True)
    except Exception:
        PLIST.rename(PLIST.with_suffix(".plist.not-enabled"))
        raise
    print("Enabled hourly background checks. Running App will not be stopped or replaced.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--disable", action="store_true")
    args = parser.parse_args()
    enable(args.disable)
