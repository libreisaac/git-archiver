# Git Archiver

This repository contains two simple scripts:

- `clone-repos.sh` - Reads a `repos.list` file from the working directory, which should contain a list of repository URLs to clone. Attempts to clone each repository (recursively with submodules), then calls the `update-repos.sh` script.
- `update-repos.sh` - Iterates over each directory in the working directory, performing a `git pull --all` then checking out and updating (recursively with submodules) every branch and tag in each directory.

Some public repositories may contain submodules on older branches or tags which are no longer publicly available. As such, it is recommended you use a Git credential manager (or just `git config --global credential.helper cache`) so you at most need to enter your credentials once per server when cloning/updating all of the repositories. Annoyingly, the cache credential manager won't store your credentials if the clone fails; you may need to run a git command which requires credentials (such as pulling a private repo) before running the update script if it keeps prompting you for credentials for the same site. If your `repos.list` contains private repositories which require authentication, placing them first should avoid this problem.

These scripts are dumb; they don't pay attention to output, so you may want to keep an eye on them as they run in case something unexpected happens.

## Repos.list

The repos.list file should contain a single repository URL on each line, for example:

```
https://github.com/libreisaac/git-archiver
git@github.com:libreisaac/git-archiver.git
```

Note that duplicates are OK; the second will just fail to clone as it already exists.

You can clone a repository into a different directory than the default (based on repository name) like:

```
https://github.com/libreisaac/git-archiver some-other-directory
```

Each line is passed as a raw argument to the clone function in the clone script; don't do anything stupid.
