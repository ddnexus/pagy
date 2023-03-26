# Chore PR merge

Consider the following git graph:

```mermaid
gitGraph
    branch master
    checkout master
    commit

    commit
    branch chore-1
    checkout chore-1
    commit id: "1"
    checkout master
    commit
    commit
    branch chore-2
    checkout chore-2
    commit id: "chore-2"
    checkout master
    commit
    cherry-pick id: "1"
    cherry-pick id: "chore-2"
```

(The graph above uses "cherry-pick" labels, but you can rebase if you want to.)

The process:

1. Pick the oldest chore PR first
2. Check the tests pass
3. `@dependabot rebase`
4. Check rebase completes (one way or another)
5. If rebased, check tests pass
6. Squash and merge
7. Repeat with the remaining chore PRs


