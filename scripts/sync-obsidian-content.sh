#!/usr/bin/env bash
set -euo pipefail

source_dir="/Users/liangshuang/Desktop/梁爽的第二大脑/08 LSwithyou海图室🚢/"
site_dir="$(cd "$(dirname "$0")/.." && pwd)"
staging_dir="$(mktemp -d)"

cleanup() {
  rm -rf "$staging_dir"
}
trap cleanup EXIT

if [[ ! -d "$source_dir" ]]; then
  echo "没有找到 Obsidian 文件夹：$source_dir"
  exit 1
fi

rsync -a \
  --exclude='.DS_Store' \
  --exclude='.obsidian/' \
  "$source_dir" "$staging_dir/"

while IFS= read -r -d '' folder; do
  if [[ ! -f "$folder/index.md" ]]; then
    folder_name="$(basename "$folder")"
    {
      printf '%s\n' '---'
      printf 'title: "%s"\n' "$folder_name"
      printf '%s\n\n' '---'
      printf '# %s\n\n' "$folder_name"
      printf '%s\n' '这里的内容正在整理中。'
    } > "$folder/index.md"
  fi
done < <(find "$staging_dir" -mindepth 1 -type d -print0)

{
  printf '%s\n' '---'
  printf '%s\n' 'title: "LSwithyou 海图室🚢"'
  printf '%s\n' 'description: "梁爽的第二大脑公开航海图"'
  printf '%s\n\n' '---'
  printf '%s\n\n' '# 欢迎来到 LSwithyou 海图室 🚢'
  printf '%s\n\n' '这里是一间持续生长的公开知识库。'
  printf '%s\n\n' '> [!note] 建设进度'
  printf '%s\n\n' '> 海图室目前正在搭建框架。新的内容会持续补充，公开链接保持不变。'
  printf '%s\n\n' '## 从这里开始'
  find "$staging_dir" -mindepth 1 -maxdepth 1 -type d -print |
    LC_ALL=C sort |
    while IFS= read -r folder; do
      folder_name="$(basename "$folder")"
      printf -- '- [[%s/index|%s]]\n' "$folder_name" "$folder_name"
    done
} > "$staging_dir/index.md"

rsync -a --delete "$staging_dir/" "$site_dir/content/"

echo "海图室内容已同步到网站副本。"
