#!/usr/bin/env bash
set -e  # Exit on error

# set environment variables used in build-hook scripts
DOCKER_REPO="cryptopath/offlineimap"
DOCKER_TAG="$(cat VERSION)"
GIT_SHA1="$(git rev-parse HEAD)"

# source-in build hook
source hooks/build

# source-in post_push hook (but don't push, only tag)
source hooks/post_push --no-push
