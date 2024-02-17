#!/usr/bin/env bash

set -e

# Exit if the working tree is dirty
test -n "$(git status --porcelain)" && echo "Working tree dirty!" && exit 1

# Set the root path
dir="$(dirname -- "$0")"
ROOT="$(cd -P -- "$(dirname -- "$dir")" && printf '%s\n' "$(pwd -P)")"
cd $ROOT

# Prompt for the new version
old_vers=$(ruby -Ilib -rpagy -e 'puts Pagy::VERSION')
echo     "Current Pagy::VERSION: $old_vers"
read -rp 'Enter the new version> ' new_vers

# Check the new version
[[ -z $new_vers ]] && echo 'Missing new version!' && exit 1
num=$(echo "$new_vers" | grep -o '\.' | wc -l)
[[ $num == 2 ]] || (echo 'Incomplete semantic version!' && exit 1)

# Bump version in files
esc_old_vers=${old_vers//./\\.}
esc_new_vers=${new_vers//./\\.}
function bump(){
	sed -i "0,/$esc_old_vers/{s/$esc_old_vers/$esc_new_vers/}" "$1"
}

bump "$ROOT/retype.yml"
bump "$ROOT/.github/.env"
bump "$ROOT/lib/pagy.rb"
bump "$ROOT/lib/config/pagy.rb"
bump "$ROOT/src/pagy.ts"

# Bumps docs example
esc_old_minor_vers=${esc_old_vers%\\*}
esc_new_minor_vers=${esc_new_vers%\\*}
sed -i "0,/$esc_old_minor_vers/{s/$esc_old_minor_vers/$esc_new_minor_vers/}" "$ROOT/quick-start.md"

cd "$ROOT/src"
pnpm run build
cd "$ROOT"

# Update CHANGELOG
changelog=$(cat <<-LOG
	<hr>

	## Version $new_vers

	$(git log --format="- %s%b" "$old_vers"..HEAD)
LOG
)
CHANGELOG="$ROOT/CHANGELOG.md"
TMPFILE=$(mktemp)
awk -v l="$changelog" '{sub(/<hr>/, l); print}' "$CHANGELOG" > "$TMPFILE"
mv "$TMPFILE" "$CHANGELOG"

# Run test to check the consistency across files
bundle exec ruby -Itest test/pagy_test.rb --name  "/pagy::Version match(#|::)/"

# Optional update of top 100
read -rp 'Do you want to update the "Top 100 contributors"? (y/n)> ' input
if [[ $input = y ]] || [[ $input = Y ]]; then
  bundle exec "$ROOT/script/update_top100.rb"
fi

## Optional show diff
#read -rp 'Do you want to see the diff? (y/n)> ' input
#if [[ $input = y ]] || [[ $input = Y ]]; then
#  git diff -U0 --word-diff=color
#fi
#
## Optional commit
#read -rp 'Do you want to commit the changes? (y/n)> ' input
#if [[ $input = y ]] || [[ $input = Y ]]; then
#  git add -A
#  git commit -m "Version $new_vers"
#fi
