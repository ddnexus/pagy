# Chore PR merge

The `admin` branch is the branch used for chores. It fast-forwards to `master` when `master` gets new commits. It receives chore PRs, and `master` fast-forwards to it when the a chore PR is merged.
 
## Merging

- Ensure that `admin` is on the same commit of `master` before merging the chore PR. If it's not, then move it there and add a comment in the chore PR with the content `@dependabot rebase` and wait for its execution
- Proceed to the chore PR merge with "Squash and merge", leaving the title, but removing the whole description
- Check whether the workflow went well for the `admin` branch
- Fast forward `master` to `admin`
- (dd only) If needed: rebase `dev` on the new `master` and check the `dev` workflow
