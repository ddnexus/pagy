# Git Hooks

A hook to ensure consistency and automation. Please setup the hook if you contribute to pagy with PRs. 

See also the brief description inside the hook file.

## Setup

### Symlink

Symlink the hook into the `.git/hooks` dir:

```shell
# from the repo root
ln -s ../../scripts/hooks/pre-commit .git/hooks 
```

### Copy

Only for filesystem that don't support symlinks: copy the hooks into the `.git/hooks` dir:

```shell
# from the repo root
cp scripts/hooks/pre-commit .git/hooks 
```
