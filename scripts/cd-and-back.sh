#!/usr/bin/env bash

# Source to cd to the script name and go back on exit

set -e

initial_pwd=$PWD

back() {
    cd "$initial_pwd"
}
trap back EXIT

# Set the sdir path
script_path="$(cd -P -- "$(dirname -- "$0")" && printf '%s\n' "$(pwd -P)")"
cd $script_path
