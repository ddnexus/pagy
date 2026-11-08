---
name: merge-pr
description: Merge one or more pagy pull requests the way the maintainer wants (base branch, squash subject with the 💎 prefix, empty body, local branches updated). Use when asked to merge, land or handle a PR.
---

# Merging a pull request

This is the procedure for merging a PR in pagy. Run it only when asked to merge: checking a PR
never implies merging it. When several PRs are open, process them from the oldest to the newest.

## Where a PR lands

A PR from a GitHub bot (dependabot, workflow bumps) stays on `master` and is merged there.

A PR from a user lands on `dev`, never on `master`: change its base first.

```sh
gh pr edit N --base dev
```

`master` may receive directly only what keeps the code identical to the published gem: docs
fixes, workflows, scripts, tests and other chores. Any change under `gem/` goes on `dev`.

## Before merging

The PR must be rebased on the tip of its base branch and its checks must be green. For a bot
PR that is behind, comment `@dependabot rebase`. For a user PR that is behind, rebase locally
and push to the fork; `--force-with-lease` to a bare URL fails, so add the fork as a remote
first or use plain `--force`.

```sh
git fetch origin pull/N/head:pr-N
git rebase dev pr-N
git remote add <user> https://github.com/<user>/pagy.git && git fetch <user>
git push --force-with-lease <user> pr-N:<branch>
```

## The squash commit

Always squash-merge. The subject is the PR title followed by ` (#N)`, which is what GitHub
proposes. When the PR touches any file under `gem/`, prepend `💎 ` to the subject: the release
script builds the CHANGELOG from the `💎` commits and warns about unmarked gem commits. Add
` (Fix #issue)` when the PR closes an issue. The body is always empty.

```sh
gh pr merge N --squash --subject "💎 <PR title> (#N)" --body ""
```

Since the body is empty, GitHub does not close the issue linked in the PR body: check it and
close it by hand.

```sh
gh issue close N --comment "Fixed by #PR, merged on dev; it will be in the next release."
```

## After merging

Fast-forward the local branch that received the merge and delete the temporary branch.

```sh
git pull --ff-only origin dev        # or master for a bot PR
git branch -D pr-N
```

After a merge on `master`, `dev` must follow: fast-forward local `dev` on the new `master` and
push it. If `dev` has its own commits, rebase them on `master` and push with
`--force-with-lease`. `origin/dev` is never left behind `master`.
