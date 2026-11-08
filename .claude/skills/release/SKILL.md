---
name: release
description: Release a new pagy version the way the maintainer wants (version picked from the 💎 commits, bump script run without prompts, CI, release workflow, branches brought in line). Use when asked to release, publish or ship a version, or to run the release skill.
---

# Releasing a version

This is the procedure for releasing pagy. Run it only when asked to release. The request authorizes
every step below, including the `Version X.Y.Z` commit and the pushes that the project rules
otherwise reserve to the maintainer, so do not ask for confirmations along the way. Report at the
end with the version released and the link to the GitHub release.

## Preconditions

Work on `dev`, in line with `origin/dev`, with a clean working tree. A dirty tree stops the release:
report what is uncommitted and stop, without committing or stashing it.

```sh
git status --porcelain                          # must be empty
git fetch --tags origin && git rev-parse dev origin/dev   # must be the same commit
```

## The version

The changes of the release are the commits since the latest tag whose subject starts with `💎`.
Read their subjects, and their diffs when a subject leaves a doubt, and pick the bump.

```sh
tag=$(git describe --tags --abbrev=0 origin/master)
git log --format='%h %s' "$tag"..dev
```

The bump is a patch when every change is a fix, a performance improvement or an internal change. It
is a minor when at least one change adds something (an option, a helper, a locale) or deprecates
something. A major is never picked here: a breaking change stops the procedure, report it and ask.

Also list the commits that change `gem/` without the `💎`. Read each diff: when it changes what the
gem does, its line goes into the changelog in the editing step below; otherwise ignore it.

```sh
git log --format='%h %s' "$tag"..dev -- gem | grep -v '💎'
```

## The bump

Run the bump script with every question answered, so it never waits for a terminal: go on with
unmarked commits, skip the edits, update the top 100 contributors, update the top adopters only for a
minor (it scrapes GitHub and rewrites all the tiles, which is slow and noisy for a patch), and do not
commit. The token lifts the GitHub rate limit for the adopters update.

```sh
scripts/bump.rb patch --no-abort-on-unmarked --no-edit --top100 --no-adopters --no-commit
GITHUB_TOKEN=$(gh auth token) scripts/bump.rb minor --no-abort-on-unmarked --no-edit --top100 --adopters --no-commit
```

The script prints the gitlog and writes the changes into `docs/CHANGELOG.md` and
`.github/latest_release_body.md`. Edit those two files only to add the line of an unmarked commit
found above, or to reword a subject that a user of the gem would not understand, keeping the two
files identical. Then commit and push.

```sh
git add -A && git commit -m "Version X.Y.Z" && git push origin dev
```

## CI and the release workflow

The push triggers the API and E2E test workflows on `dev`. Wait for both; a failure stops the release,
report the failing job.

```sh
sleep 30 && gh run list --branch dev --limit 2 --json databaseId,name,headSha   # the two runs of the Version commit
gh run watch <id> --exit-status
```

Then dispatch the release workflow and wait for it. It checks the version, merges `dev` into `master`,
tags, publishes the gem, creates the GitHub release and publishes the docs.

```sh
gh workflow run release.yml -f version=X.Y.Z
sleep 10 && id=$(gh run list --workflow release.yml --limit 1 --json databaseId --jq '.[0].databaseId')
gh run watch "$id" --exit-status
```

When the request asks for a dry run, add `-f dry_run=true`: the workflow then stops after building the
gem, and so does this procedure.

## Verification

Check that the release, the gem and the docs are out.

```sh
gh release view X.Y.Z --json tagName,url
curl -s https://rubygems.org/api/v1/versions/pagy/latest.json
gh run list --workflow publish-docs.yml --limit 1 --json status,conclusion
```

## Branches

The workflow merges `dev` into `master` with a merge commit that `dev` must receive: `origin/dev` is
never left behind `master`. Update local `master` too.

```sh
git fetch origin master:master      # fast-forwards local master, which is not checked out
git merge --ff-only origin/master   # on dev
git push origin dev
```
