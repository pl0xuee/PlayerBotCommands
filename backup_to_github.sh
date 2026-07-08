#!/usr/bin/env bash

set -euo pipefail

BACKUP_ROOT="/home/jamespc/Documents/Projects/Backups/PlayerBotCommands"
GITHUB_REMOTE_NAME="backup-github"
GITHUB_REMOTE_URL="https://github.com/pl0xuee/PlayerBotCommands"
REMOTE_BACKUP_BRANCH="main"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

timestamp="$(date +"%Y-%m-%d_%H-%M-%S")"
repo_name="$(basename "$REPO_DIR")"
archive_path="$BACKUP_ROOT/${repo_name}_$timestamp.tar.gz"
tmp_root="$(mktemp -d)"
snapshot_dir="$tmp_root/$repo_name"

cleanup() {
    rm -rf "$tmp_root"
}

require_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "Missing required command: $1" >&2
        exit 1
    fi
}

copy_snapshot() {
    mkdir -p "$snapshot_dir"
    tar \
        --exclude='.git' \
        --exclude='node_modules' \
        --exclude='dist' \
        --exclude='build' \
        -cf - \
        -C "$REPO_DIR" \
        . | tar -xf - -C "$snapshot_dir"
}

trap cleanup EXIT

require_command git
require_command tar
require_command date
require_command mktemp

mkdir -p "$BACKUP_ROOT"

echo "Creating local archive: $archive_path"
tar \
    --exclude='.git' \
    --exclude='node_modules' \
    --exclude='dist' \
    --exclude='build' \
    -czf "$archive_path" \
    -C "$(dirname "$REPO_DIR")" \
    "$repo_name"

git init "$snapshot_dir" >/dev/null
git -C "$snapshot_dir" remote add "$GITHUB_REMOTE_NAME" "$GITHUB_REMOTE_URL"

if git ls-remote --exit-code --heads "$GITHUB_REMOTE_URL" "$REMOTE_BACKUP_BRANCH" >/dev/null 2>&1; then
    echo "Fetching existing remote backup branch"
    git -C "$snapshot_dir" fetch --depth=1 "$GITHUB_REMOTE_NAME" "$REMOTE_BACKUP_BRANCH"
    git -C "$snapshot_dir" checkout -B "$REMOTE_BACKUP_BRANCH" FETCH_HEAD >/dev/null
    find "$snapshot_dir" -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} +
else
    git -C "$snapshot_dir" checkout --orphan "$REMOTE_BACKUP_BRANCH" >/dev/null
fi

copy_snapshot

git -C "$snapshot_dir" config user.name "${GIT_AUTHOR_NAME:-PlayerBot Backup}"
git -C "$snapshot_dir" config user.email "${GIT_AUTHOR_EMAIL:-backup@local.invalid}"
git -C "$snapshot_dir" add -A

if git -C "$snapshot_dir" diff --cached --quiet; then
    echo "No content changes since the last GitHub backup"
else
    commit_message="Backup $timestamp"
    echo "Creating remote backup commit: $commit_message"
    git -C "$snapshot_dir" commit -m "$commit_message" >/dev/null
fi

echo "Pushing backup branch '$REMOTE_BACKUP_BRANCH' to '$GITHUB_REMOTE_NAME'"
git -C "$snapshot_dir" push "$GITHUB_REMOTE_NAME" "HEAD:refs/heads/$REMOTE_BACKUP_BRANCH"

echo "Backup completed"
echo "Local archive: $archive_path"
echo "Remote branch: $GITHUB_REMOTE_URL (branch $REMOTE_BACKUP_BRANCH)"