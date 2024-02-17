#!/usr/bin/env bash

set -e

# Exit if the working tree is dirty
test -n "$(git status --porcelain)" && echo "Working tree dirty!" && exit 1

# Exit if is not a releasable branch
[[ "$(git rev-parse --abbrev-ref HEAD)" == master* ]] || echo "Wrong branch to release!" && exit 1

# Set the root path
dir="$(dirname -- "$0")"
ROOT="$(cd -P -- "$(dirname -- "$dir")" && printf '%s\n' "$(pwd -P)")"
cd $ROOT

rake build release

rm -rfv "$ROOT/pkg"
