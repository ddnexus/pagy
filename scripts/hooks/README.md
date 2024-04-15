# Git Hooks

A few hooks to ensure consistency and automation. Please setup the hooks if you contribute to pagy with PRs. 

See also the brief description inside each hook file.
    
## Setup

### Symlink

Symlink the hooks into the `.git/hooks` dir:

```shell
# from the repo root
ln -s ../../scripts/hooks/{pre-commit,commit-msg} .git/hooks 
```

### Copy

Only for filesystem that don't support symlinks: copy the hooks into the `.git/hooks` dir:

```shell
# from the repo root
cp scripts/hooks/{pre-commit,commit-msg} .git/hooks 
```
