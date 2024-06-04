#!/usr/bin/env bash

set -e

# Abort if the working tree is dirty
[[ -z "$(git status --porcelain)" ]] || (>&2 echo "Working tree dirty!" && exit 1)

# Set the root path
dir="$(dirname -- "$0")"
root="$(cd -P -- "$(dirname -- "$dir")" && printf '%s\n' "$(pwd -P)")"
cd $root

# Prompt for the new version
old_vers=$(ruby -Igem/lib -rpagy -e 'puts Pagy::VERSION')
echo "Current Pagy::VERSION: $old_vers"
read -rp 'Enter the new version> ' new_vers

# Abort if the version is invalid
[[ -n $new_vers ]] || ( >&2 echo 'Missing new version!' && exit 1)
num=$(echo "$new_vers" | grep -o '\.' | wc -l | xargs)
[[ $num == 2 ]] || (>&2 echo 'Incomplete semantic version!' && exit 1)

# Abort if there is no gem change
[[ -n $(git diff --name-only --relative=gem "$old_vers"..HEAD) ]] || \
	(>&2 echo "No gem changes since version $old_vers!" && exit 1)

# Bump version in files
esc_old_vers=${old_vers//./\\.}
esc_new_vers=${new_vers//./\\.}
function bump(){
	sed -i "0,/$esc_old_vers/{s/$esc_old_vers/$esc_new_vers/}" "$1"
}

bump "$root/retype.yml"
bump "$root/.github/ISSUE_TEMPLATE/Code.yml"
bump "$root/.github/latest_release_body.md"
bump "$root/gem/apps/calendar.ru"
bump "$root/gem/apps/demo.ru"
bump "$root/gem/apps/rails.ru"
bump "$root/gem/apps/repro.ru"
bump "$root/gem/bin/pagy"
bump "$root/gem/config/pagy.rb"
bump "$root/gem/lib/pagy.rb"
bump "$root/gem/pagy.gemspec"
bump "$root/src/pagy.ts"

# Build javascript files
cd "$root/src"
./build.sh
cd "$root"

# Bumps docs example
esc_old_minor_vers=${esc_old_vers%\\*}
esc_new_minor_vers=${esc_new_vers%\\*}
sed -i "0,/$esc_old_minor_vers/{s/$esc_old_minor_vers/$esc_new_minor_vers/}" "$root/quick-start.md"

# Set tmplog to the commit messages that have changes in the "gem" root path
tmplog=$(mktemp)
# Iterate through the new commits
for commit in $(git rev-list "$old_vers"..HEAD)
do
	if [[ -n $(git show --pretty="format:" --name-only --relative=gem $commit) ]]
	then
		git show --no-patch --format="- %s" $commit >> "$tmplog"
		body=$(git show --no-patch --format="%b" $commit)
		if [[ -n "$body" ]]
		then
			sed 's/^/\ \ /' <<<"$body" >> "$tmplog"
		fi
	fi
done

# Insert the changes in the the release body file used by .github/workflows/create_release.yml
# which is triggered by the :rubygem_release task (push tag)
lead='^<!-- changes start -->$'
tail='^<!-- changes end -->$'
sed -i "/$lead/,/$tail/{ /$lead/{p; r $tmplog
		}; /$tail/p; d }" "$root/.github/latest_release_body.md"

# Update CHANGELOG
changelog=$(cat <(echo -e "<hr>\n\n## Version $new_vers\n") "$tmplog")
changelog_path="$root/CHANGELOG.md"
awk -v l="$changelog" '{sub(/<hr>/, l); print}' "$changelog_path" > "$tmplog"
mv "$tmplog" "$changelog_path"

# Run test to check the consistency across files
bundle exec ruby -Itest test/pagy_test.rb --name  "/pagy::Version match(#|::)/"

# Optional update of top 100
read -rp 'Do you want to update the "Top 100 contributors"? (y/n)> ' input
if [[ $input = y ]] || [[ $input = Y ]]; then
	bundle exec "$root/scripts/update_top100.rb"
fi

# Optional commit
read -rp 'Do you want to commit the changes? (y/n)> ' input
if [[ $input = y ]] || [[ $input = Y ]]; then
	git add -A
	git commit -m "Version $new_vers"
fi
