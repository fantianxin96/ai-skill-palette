"""Exercise the News model extracted from production Swift source; no App/Skill launch."""
from pathlib import Path
import re
import subprocess
import tempfile
import uuid

root = Path(__file__).resolve().parents[1]
source = (root / "Sources/GlobalSkillPalette.swift").read_text()
ids = re.findall(r'            id: "([^"]+)"', source)
assert len(ids) == len(set(ids)), "Duplicate card IDs"
model = source.split("// NEWS_STATE_BEGIN\n", 1)[1].split("// NEWS_STATE_END", 1)[0]
assertions = 'let suite = "palette.news.tests.\\(UUID().uuidString)"\nlet defaults = UserDefaults(suiteName: suite)!\ndefer { defaults.removePersistentDomain(forName: suite) }\nlet state = CardNewsState(defaults: defaults)\nfunc check(_ value: Bool, _ label: String) {\n    precondition(value, label)\n    print("PASS: \\(label)")\n}\ncheck(!state.showsNews(cardID: "legacy", isNew: false), "legacy baseline has no News")\ncheck(state.showsNews(cardID: "new-a", isNew: true), "new card starts with News")\ncheck(!state.recordCopy(cardID: "new-a", succeeded: false), "failed clipboard write rejected")\ncheck(state.showsNews(cardID: "new-a", isNew: true), "failed copy preserves News")\ncheck(state.recordCopy(cardID: "new-a", succeeded: true), "successful clipboard write recorded")\ncheck(!state.showsNews(cardID: "new-a", isNew: true), "copied card hides News")\ncheck(state.showsNews(cardID: "new-b", isNew: true), "distinct card with same command remains new")\nlet reopened = CardNewsState(defaults: UserDefaults(suiteName: suite)!)\ncheck(!reopened.showsNews(cardID: "new-a", isNew: true), "new store instance retains copied ID")\ncheck(reopened.showsNews(cardID: "next-week", isNew: true), "later weekly addition starts new")\nstate.recordCopy(cardID: "new-a", succeeded: true)\ncheck(state.copiedIDs == Set(["new-a"]), "repeat copy is idempotent")\ncheck(defaults.stringArray(forKey: CardNewsState.storageKey) == ["new-a"], "persistent value uses stable card ID")\n\nlet arguments = CommandLine.arguments\nif arguments.count == 3 {\n    let persistentDefaults = UserDefaults(suiteName: arguments[2])!\n    let persistent = CardNewsState(defaults: persistentDefaults)\n    if arguments[1] == "write" {\n        persistent.recordCopy(cardID: "process-restart-card", succeeded: true)\n        persistentDefaults.synchronize()\n        print("PASS: copied ID written by first process")\n    } else {\n        check(!persistent.showsNews(cardID: "process-restart-card", isNew: true), "second process retains copied card after restart")\n        persistentDefaults.removePersistentDomain(forName: arguments[2])\n        persistentDefaults.synchronize()\n    }\n}\n'
with tempfile.TemporaryDirectory(prefix="palette-news-test-") as work:
    work = Path(work)
    swift = work / "NewsStateTests.swift"
    binary = work / "news-state-tests"
    swift.write_text("import Foundation\n" + model + assertions)
    subprocess.run(["xcrun", "swiftc", "-module-cache-path", str(work / "cache"), str(swift), "-o", str(binary)], check=True)
    domain = "palette.news.process-test." + str(uuid.uuid4())
    for mode in ("write", "read"):
        subprocess.run([str(binary), mode, domain], check=True)
