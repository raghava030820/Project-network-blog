#!/usr/bin/env bash
set -euo pipefail

# new-post.sh — create a Hugo page bundle for a new blog post.
#
# Usage:
#   ./scripts/new-post.sh "My Post Title"
#   ./scripts/new-post.sh            # prompts for the title
#
# Creates: content/posts/<slug>/index.md  (+ an images/ folder)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
POSTS_DIR="$ROOT_DIR/content/posts"

TITLE="${1:-}"
if [ -z "$TITLE" ]; then
  read -r -p "Post title: " TITLE
fi
if [ -z "$TITLE" ]; then
  echo "No title given. Aborting." >&2
  exit 1
fi

# Turn the title into a URL-friendly slug: "My Post Title!" -> "my-post-title"
SLUG="$(printf '%s' "$TITLE" \
  | tr '[:upper:]' '[:lower:]' \
  | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')"
[ -z "$SLUG" ] && SLUG="post"

DIR="$POSTS_DIR/$SLUG"
if [ -e "$DIR" ]; then
  echo "Post already exists: $DIR" >&2
  exit 1
fi

mkdir -p "$DIR/images"

DATE="$(date +%F)"
cat > "$DIR/index.md" <<EOF
---
title: "$TITLE"
date: $DATE
draft: true
tags: []
categories: []
summary: ""
# cover:
#   image: "cover.svg"
#   alt: "$TITLE"
---

Write your post here. Put images in the images/ folder next to this file and
reference them by filename only:

![description](images/your-image.png)
EOF

echo "Created $DIR"
echo "  index.md"
echo "  images/"

# Open in an editor if one is available.
if [ -n "${EDITOR:-}" ]; then
  "$EDITOR" "$DIR/index.md"
elif command -v code >/dev/null 2>&1; then
  code "$DIR/index.md"
elif command -v nano >/dev/null 2>&1; then
  nano "$DIR/index.md"
fi
