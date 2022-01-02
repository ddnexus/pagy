#!/usr/bin/env bash

set -e

e2e_dir="$(cd -P -- "$(dirname -- "$0")" && printf '%s\n' "$(pwd -P)")"
cd "$e2e_dir/.."
npm ls -w e2e | tee "$e2e_dir/ci-cache.lock"
