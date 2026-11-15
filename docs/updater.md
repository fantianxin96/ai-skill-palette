# GitHub 到本机 App 的安全后台更新

版本 120 的链路：GitHub main → 固定 commit → 独立下载与编译 → ready → App 退出后安全替换 → 下次启动健康确认。运行 App 时不会 kill、替换或弹出面板。更新器安装目标固定为 `/Applications/AI Skill Palette.app`。

## 启用与停用

先确认 App 已安装且归当前用户所有，并已安装 Xcode Command Line Tools。无需管理员权限、token 或新系统访问权限。

```sh
/usr/bin/python3 scripts/enable-updater.py
# 关闭后台检查；保留 App、状态及备份
/usr/bin/python3 scripts/enable-updater.py --disable
```

用户 LaunchAgent 每小时运行一次并在注册时运行。初始旧版没有菜单时，候选会等待自然退出后下次检查才替换；不会强制中断。119 起菜单支持检查、状态详情、确认更新重启或稍后。确认重启后的后台启动不抢焦点、不自动显示面板。仅启用自动准备不能宣称已替换当前 App。

## 状态及回执

用户私有目录 `~/Library/Application Support/AI Skill Palette/Updater` 存放：

- status.json：checking/building/ready/installed_pending_launch/current/error/conflict/version_not_bumped。
- manifest.json：候选 commit、build、源码/helper/binary SHA-256、原 App 与候选文件指纹。
- receipt.json：已替换版本、备份位置与安装时间。
- health.json：实际启动版本、commit 与启动时间；必须匹配安装回执和二进制才确认。
- error.json 和 worker 日志：最近失败原因。失败不等于旧 App 不可用。

`ready` 表示后台候选完成，当前仍为旧版；`installed_pending_launch` 表示替换成功但启动未确认；`current` 的健康确认需对应回执，普通无新版本检查不代表测试过 UI。

## 来源及版本保护

固定公开仓库 `fantianxin96/ai-skill-palette`，无鉴权请求；只允许 HTTPS api.github.com/raw.githubusercontent.com，拒绝重定向、凭据 URL 和超限响应。先取 main SHA，再按固定 SHA 下载 build.sh、Swift 源码、updater.py 与 AppIcon.icns。仅解析 build.sh 的数字版本，不执行它；使用本机固定 swiftc 与 codesign 命令，不执行远端安装脚本或 Skill。

候选必须比本机 build 新。同版本文档变化不更新 App；已知同版本可执行内容变化报告 version_not_bumped。单实例锁阻止并发操作。安装前再次检查 App 文件指纹；手动变动或候选篡改则停止，避免覆盖。拒绝目标或状态路径的符号链接。

普通用户级 bootstrap 仅负责检查/暂存与闲时替换，不使用 sudo、特权 helper、清 quarantine 或修改 Gatekeeper。签名为本机 ad-hoc 签名，哈希保证内容一致性，不构成独立发布者签名认证；GitHub main 的审核与账号安全仍是信任边界。

## 备份、失败与限制

替换前写入持久事务并保留旧 bundle；候选改名失败恢复旧 bundle，后台进程在替换中断后由下次任务按事务恢复。菜单确认后必须收到后台锁与完整预检的握手回执，App 才正常退出。编译、网络、签名、权限或冲突失败时保留原 App 并写状态；不触碰工作仓库、stash、Skills、用户偏好或 News 已复制记录。后续 App 启动失败不会立即自动回退：旧备份保留，报告未确认，需要明确处置。

当前 bootstrap 是启用时复制的已审查版本；其自身升级需要单独审查和部署，不能声称后台服务也会自更新。候选 App 中的 helper 随 App 更新。任务暂存期间 main 继续变化时先完成既有候选，不混合提交；后续检查再处理更新。

## 验证

`/usr/bin/python3 -m unittest discover -s tests -p test_updater.py -v` 使用临时 App 和故障注入，不接触正式 App。覆盖运行中延后、安装冲突、候选篡改、降级、并发、编译失败、替换失败恢复、健康回执和 URL 拒绝。真实启用后另外核对 LaunchAgent、commit/候选版本、签名、状态与原 App 指纹，不能只以单元测试声称已生效。

路径迁移保护：保守识别任何 AISkillPalette 可执行进程，而不是只比较当前安装路径。从旧路径启动的实例未退出时也等待，避免 bundle 移动后误判闲时。
