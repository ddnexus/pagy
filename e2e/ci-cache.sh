#!/usr/bin/env bash

# Create the cache file used in GitHub Actions to get the right e2e env
set -e

e2e_dir="$(cd -P -- "$(dirname -- "$0")" && printf '%s\n' "$(pwd -P)")"
cd "$e2e_dir"
pnpm ls | tee "$e2e_dir/ci-cache.lock"
