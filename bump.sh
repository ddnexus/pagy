#!/usr/bin/env bash

set -e

ROOT="$(cd -P -- "$(dirname -- "$0")" && printf '%s\n' "$(pwd -P)")"

cur=$(ruby -Ilib -rpagy -e 'puts Pagy::VERSION')
current=${cur//./\\.}

echo     "Current Pagy::VERSION: $cur"
read -rp 'Enter the new version> ' ver

[[ -z $ver ]] && echo 'Missing new version!' && exit 1
num=$(echo "$ver" | grep -o '\.' | wc -l)
[[ $num == 2 ]] || (echo 'Incomplete semantic version!' && exit 1)

version=${ver//./\\.}

# Bump version in files
function bump(){
	sed -i "0,/$current/{s/$current/$version/}" "$1"
}


bump "$ROOT/.github/.env"
bump "$ROOT/lib/pagy.rb"
bump "$ROOT/lib/config/pagy.rb"
bump "$ROOT/lib/javascripts/pagy.js"

current_minor=${current%\\*}
version_minor=${version%\\*}
sed -i "0,/$current_minor/{s/$current_minor/$version_minor/}" "$ROOT/docs/how-to.md"


# Update CHANGELOG
log=$(cat <<-LOG
	<hr>

	## Version $ver

	$(git log --format="- %s%b" "$cur"..HEAD)
LOG
)

CHANGELOG="$ROOT/CHANGELOG.md"
TMPFILE=$(mktemp)
awk -v l="$log" '{sub(/<hr>/, l); print}' "$CHANGELOG" > "$TMPFILE"
mv "$TMPFILE" "$CHANGELOG"


# Run test to check the consistency across files
bundle exec ruby -Itest test/pagy_test.rb --name  "/pagy::Version match(#|::)/"


# Show diff
git diff -U0


# Optional commit
read -rp 'Do you want to commit the changes? (y/n)> ' input
if [[ $input = y ]] || [[ $input = Y ]]; then
  git add .github/.env lib/pagy.rb lib/config/pagy.rb lib/javascripts/pagy.js docs/how-to.md CHANGELOG.md
  git commit -m "Version $ver"
fi
