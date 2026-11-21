# App 无窗口：调查与待桌面验证修复（2026-11-21）

用户确认：点 App 没有窗口。优先恢复现有应用，保留数据/复制记录，不强退。

## 已观察事实
- 正式 /Applications/AI Skill Palette.app 仍为build120，arm64可执行文件存在、可执行，codesign --verify --deep --strict成功，SHA256仍596c0987af99d85bde920dd487823db914222cc12e68f2314c0a6b77412d4f27。121未替换，不把此次无窗口归因于已安装121。
- Dock条目指向正式/Applications路径，未发现该条目指向旧副本。
- 当前会话open命令报LaunchServices -10827，但磁盘可执行文件并未缺失；不能照错误标签推断文件丢失。
- 本会话直接执行正式二进制exit134，产生22:49报告，parent=codex；主线程在_RegisterApplication / NSApplication.shared初始化中止，尚未进入AppDelegate。此报告仅证明本次受限启动失败，不证明用户在Finder/Dock启动也同样崩溃。
- 桌面控制读取持续-10005/执行超时；无真实窗口或成功启动新回执。没有通过其他进程绕过受限目录权限。

## 代码缺口及候选
App启动时显示窗口，复制/关闭后隐藏；旧AppDelegate未实现applicationShouldHandleReopen。再次点击已运行App不能依赖applicationDidFinishLaunching再次执行。新增reopen委托方法，统一调用palette.show()并返回false；不用toggle，避免已显示时反而隐藏。
这是已确认的代码缺口，但尚未确认其为本次故障唯一原因。

build122候选沿用main的56卡与更新helper，只修改reopen处理与build号。独立编译exit0；从实际生产源码提取委托方法，在无图形替身对象中执行，确认nil palette安全，hasVisibleWindows true/false两路径均调用show且返回false。此检查不替代AppKit真实事件和桌面验收。

## 交付边界
修复以草稿PR保留，暂不发布未经真实桌面验证的恢复结论。原正式App/用户偏好/News/dirty/stash未改。用户可用原快捷键⌘⇧K尝试显示现有窗口；若快捷键也无效，需恢复正式图形会话执行入口后核实启动。不要删除偏好、清缓存、重装Skills或重启整台Mac来掩盖原因。
