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

cp "$site_dir/site/homepage.md" "$staging_dir/index.md"

rsync -a --delete "$staging_dir/" "$site_dir/content/"

echo "海图室内容已同步到网站副本。"
