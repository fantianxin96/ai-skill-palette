# 灵感指令台 / AI Skill Palette

一个 macOS 全局悬浮提示词面板，给 Codex 桌面端、Claude Code、Cursor、终端、网页 AI 都能用。

## 形态

- 菜单栏常驻小图标
- 全局快捷键：`⌘⇧K`
- 悬浮窗口：搜索、按场景筛选、点击复制 prompt
- 不自动粘贴，避免误发；复制后回到 AI 输入框手动 `⌘V`
- 当前产品版本：`v1.0`

## 场景分组（v1.0）

- 想清楚：`$i-shape` / `$i-impeccable` / 产品 brief / 一条龙工作流
- 需求综合：`$i-synthesize`
- 找问题：`$i-critique` / `$i-web-interact` / `$i-app-interact`
- 定系统：`$i-system` / `$i-consistency`
- 调排版：`$i-typeset` / `$i-layout` / `$i-clarify`
- 调风格：`$i-colorize` / `$i-bolder` / `$i-quieter` / `$i-polish`
- 调交互：`$i-animate` / `$i-delight` / `$i-overdrive`
- 适配上线：`$i-adapt` / `$i-optimize` / `$i-audit` / `$i-harden` / `$i-handoff`
- 复盘沉淀：`$i-distill` / `$i-recap`

## 附带 Codex Skills

仓库内 `skills/` 目录镜像保存本次新增的 Codex skills，正式使用位置仍是：

```text
~/.codex/skills/i-system/SKILL.md
~/.codex/skills/i-consistency/SKILL.md
~/.codex/skills/i-synthesize/SKILL.md
~/.codex/skills/i-handoff/SKILL.md
~/.codex/skills/i-recap/SKILL.md
~/.codex/skills/i-web-interact/SKILL.md
~/.codex/skills/i-app-interact/SKILL.md
```

如果换电脑，可以把 `skills/` 里的对应目录复制到新机器的 `~/.codex/skills/` 目录。

## 构建

```zsh
cd /Users/fantianxin/Documents/Codex/2026-04-28/http-localhost-8081-blissful-weekend-html/global-skill-palette
./build.sh
```

构建后会生成：

```text
dist/AI Skill Palette.app
```

## 使用

1. 双击 `dist/AI Skill Palette.app`。
2. 第一次打开如果 macOS 提示安全限制，在 Finder 里右键 App，选择“打开”。
3. 打开后菜单栏会出现一个 `⌘` 小图标。
4. 使用 `⌘⇧K` 唤起/隐藏悬浮面板，也可以点菜单栏 `⌘` 图标。
5. 先选一个问题场景：
   - `想清楚`：需求、目标、用户路径还没有定准。
   - `找问题`：想让 AI 像设计评审一样找问题。
   - `调排版`：字体、布局、文案层级不舒服。
   - `调风格`：整体审美、颜色、质感、强弱需要调整。
   - `调交互`：动效、反馈、愉悦感或高级交互。
   - `适配上线`：移动端、性能、可访问性、真实边界。
   - `复盘沉淀`：删复杂度、去噪、记录 AI 协作和设计思路。
6. 点击条目后 prompt 会复制到剪贴板，面板里会显示“已复制”和下一步提示。
7. 回到 Codex / Claude Code 输入框，按 `⌘V`。

## 为什么先做复制，不做自动粘贴

自动粘贴需要模拟键盘输入或控制当前 App，容易误发内容，也可能触发系统辅助功能权限。复制到剪贴板更稳、更安全，适合 MVP。

## Claude Code 说明

Claude Code 有 CLI / IDE / 桌面图形界面等形态。这个 palette 不依赖具体工具，所以 Codex 桌面端、Claude Code 桌面端、终端里的 Claude Code 都可以用。
