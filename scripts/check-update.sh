#!/bin/bash
# ===========================================
# other-neko-gundan — アップデート確認スクリプト
# ===========================================
#
# 使い方:
#   bash scripts/check-update.sh [--force]
#
# オプション:
#   --force  キャッシュを無視して即時チェック
#
# SessionStartフックで自動実行する場合:
#   bash path/to/other-neko-gundan/scripts/check-update.sh &
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# --- 設定 ---
CACHE_FILE="${HOME}/.claude/.other-neko-gundan-update-cache"
CACHE_TTL=86400  # 24時間（秒）
GITHUB_API="https://api.github.com/repos/aliksir/other-neko-gundan/releases/latest"

# --- フラグ解析 ---
FORCE=false
if [ "${1:-}" = "--force" ]; then
    FORCE=true
fi

# --- ユーティリティ ---
die_silent() {
    exit 0
}

# curlがなければサイレント終了
command -v curl >/dev/null 2>&1 || die_silent

# --- キャッシュチェック ---
if [ "$FORCE" = false ] && [ -f "$CACHE_FILE" ]; then
    cache_age=$(( $(date +%s) - $(date -r "$CACHE_FILE" +%s 2>/dev/null || echo 0) ))
    if [ "$cache_age" -lt "$CACHE_TTL" ]; then
        # キャッシュ有効 — 前回の結果を表示
        cached_result=$(cat "$CACHE_FILE" 2>/dev/null || echo "")
        if [ -n "$cached_result" ] && [ "$cached_result" != "up-to-date" ]; then
            echo "$cached_result" >&2
        fi
        exit 0
    fi
fi

# --- ローカルバージョン取得 ---
local_ver=""
if [ -f "$REPO_DIR/VERSION" ]; then
    local_ver=$(cat "$REPO_DIR/VERSION" | tr -d '[:space:]')
elif [ -f "$REPO_DIR/CHANGELOG.md" ]; then
    local_ver=$(grep -o '## \[*[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\|## \[*v[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*' "$REPO_DIR/CHANGELOG.md" 2>/dev/null | head -1 | sed 's/^## \[*v*//' || echo "")
fi

# バージョン取得できなければ git describe で代替
if [ -z "$local_ver" ]; then
    local_ver=$(cd "$REPO_DIR" && git describe --tags --abbrev=0 2>/dev/null || echo "unknown")
fi

local_ver="${local_ver#v}"  # 先頭の v を除去

# --- リモートバージョン取得 ---
remote_json=$(curl -sS --max-time 10 "$GITHUB_API" 2>/dev/null || echo "")
if [ -z "$remote_json" ]; then
    echo "up-to-date" > "$CACHE_FILE"
    die_silent
fi

remote_ver=$(echo "$remote_json" | grep -o '"tag_name"[[:space:]]*:[[:space:]]*"v*[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*"' | sed 's/.*"v*\([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\)".*/\1/' || echo "")
if [ -z "$remote_ver" ]; then
    echo "up-to-date" > "$CACHE_FILE"
    die_silent
fi

# --- バージョン比較 ---
if [ "$local_ver" = "$remote_ver" ]; then
    echo "up-to-date" > "$CACHE_FILE"
    exit 0
fi

# バージョンが異なる場合 → 通知
notification=$(cat <<EOF

🔔 other-neko-gundan: 新バージョン v${remote_ver} が利用可能です（現在: v${local_ver}）
   → cd ${REPO_DIR} && git pull

EOF
)

echo "$notification" > "$CACHE_FILE"
echo "$notification" >&2
