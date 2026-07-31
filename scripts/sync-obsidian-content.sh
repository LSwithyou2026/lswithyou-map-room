#!/usr/bin/env bash
set -euo pipefail

source_dir="/Users/liangshuang/Desktop/梁爽的第二大脑/08 LSwithyou海图室🚢/"
site_dir="$(cd "$(dirname "$0")/.." && pwd)"

if [[ ! -d "$source_dir" ]]; then
  echo "没有找到 Obsidian 文件夹：$source_dir"
  exit 1
fi

rsync -a \
  --exclude='.DS_Store' \
  --exclude='.obsidian/' \
  --exclude='index.md' \
  "$source_dir" "$site_dir/content/"

echo "海图室内容已同步到网站副本。"
