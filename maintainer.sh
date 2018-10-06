#!/usr/bin/env bash

NAMESPACE=cryptopath
REPOSITORY=offlineimap

VERSION="$(cat VERSION)"


declare help="
Maintainer script for docker-offlineimap image.
Usage:
  $0 build
  $0 release
Options:
  -h --help           Show this screen.
  --version           Show version.
"

run_build() {
  BUILD_DATE="$(LC_TIME=en_US date -u +%B-%d-%Y-%H:%M:%S-UTC)"

  echo -e "BUILD_DATE:\t${BUILD_DATE}"
  echo -e "VERSION:\t${VERSION}"

  docker build --build-arg VERSION="${VERSION}" --build-arg BUILD_DATE="${BUILD_DATE}" -t $NAMESPACE/$REPOSITORY:latest .
}

run_release() {
  # ensure we're up to date
  git pull

  # bump version
  docker run --rm -v "$PWD":/app treeder/bump patch

  # update version variable and run build
  VERSION="$(cat VERSION)"
  run_build "$@"

  # tag it
  git add -A
  git commit -m "version ${VERSION}"
  git tag -a "${VERSION}" -m "version ${VERSION}"
  git push
  git push --tags
  docker tag $NAMESPACE/$REPOSITORY:latest $NAMESPACE/$REPOSITORY:${VERSION}

  # push it
  docker push $NAMESPACE/$REPOSITORY:latest
  docker push $NAMESPACE/$REPOSITORY:${VERSION}
}

version() {
  echo -e "Version: ${VERSION}.\nLicensed under the MIT terms."
}

help() {
  echo "$help"
}

main() {
  set -eo pipefail; [[ "$TRACE" ]] && set -x
  declare cmd="$1"
  case "$cmd" in
    build)        shift; run_build "$@";;
    release)      shift; run_release "$@";;
    -h|--help)    shift; help "$@";;
    --version)    shift; version;;
    *)            help "$@";;
  esac
}

main "$@"
