#!/bin/zsh
set -euo pipefail

ROOT_DIR="${0:A:h}"
APP_NAME="AI Skill Palette"
APP_SOURCE="$ROOT_DIR/dist/$APP_NAME.app"
APP_ZIP="$ROOT_DIR/downloads/AI-Skill-Palette-v1.0-mac.zip"
DESKTOP_APP="$HOME/Desktop/$APP_NAME.app"
CODEX_SKILLS_DIR="$HOME/.codex/skills"
BACKUP_DIR="$HOME/.codex/skills-backup-ai-skill-palette-$(date +%Y%m%d-%H%M%S)"

print_step() {
  printf "\n\033[1;35m%s\033[0m\n" "$1"
}

print_ok() {
  printf "\033[0;32m%s\033[0m\n" "$1"
}

print_step "安装灵感指令台 / AI Skill Palette"

if [[ ! -d "$APP_SOURCE" && -f "$APP_ZIP" ]]; then
  print_step "解压 App"
  rm -rf "$ROOT_DIR/dist"
  mkdir -p "$ROOT_DIR/dist"
  ditto -x -k "$APP_ZIP" "$ROOT_DIR/dist"
fi

if [[ ! -d "$APP_SOURCE" ]]; then
  if [[ -x "$ROOT_DIR/build.sh" ]]; then
    print_step "没有找到预打包 App，正在本机编译"
    "$ROOT_DIR/build.sh"
  else
    echo "没有找到 $APP_SOURCE，也没有可执行的 build.sh。"
    echo "请确认你下载的是完整仓库。"
    exit 1
  fi
fi

print_step "安装 App 到桌面"
rm -rf "$DESKTOP_APP"
ditto "$APP_SOURCE" "$DESKTOP_APP"
xattr -dr com.apple.quarantine "$DESKTOP_APP" 2>/dev/null || true
print_ok "已安装：$DESKTOP_APP"

if [[ -d "$ROOT_DIR/skills" ]]; then
  print_step "安装 Codex skills"
  mkdir -p "$CODEX_SKILLS_DIR"
  mkdir -p "$BACKUP_DIR"

  for skill_dir in "$ROOT_DIR"/skills/i-*; do
    [[ -d "$skill_dir" ]] || continue
    skill_name="${skill_dir:t}"
    target_dir="$CODEX_SKILLS_DIR/$skill_name"

    if [[ -d "$target_dir" ]]; then
      ditto "$target_dir" "$BACKUP_DIR/$skill_name"
    fi

    rm -rf "$target_dir"
    ditto "$skill_dir" "$target_dir"
    print_ok "已安装 skill：$skill_name"
  done

  if [[ -z "$(find "$BACKUP_DIR" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null)" ]]; then
    rmdir "$BACKUP_DIR"
  else
    print_ok "已有同名 skills 已备份到：$BACKUP_DIR"
  fi
else
  echo "没有找到 skills 目录，已跳过 Codex skills 安装。"
fi

print_step "完成"
echo "1. 双击桌面的 $APP_NAME.app 打开。"
echo "2. 如果 macOS 提示无法打开，请在 Finder 里右键 App，选择“打开”。"
echo "3. 打开后使用快捷键 ⌘⇧K 唤起灵感指令台。"
echo ""
echo "提示：App 是指令台，skills 是 Codex 能力包。两者都安装后，体验最完整。"
echo ""
read "?按回车退出..."
