---
title: Gists
permalink: blog/gists
nav_order: 1
---
# Gists

My code snippets are hosted on [GitHub’s Gists](https://gist.github.com/picaq). <br>
I plan to move them here eventually.

## Latest: git 
### update feature branch with latest changes to main/master
in the feature branch:
```sh
alias gmm='git fetch origin `git branch -l master main | sed 's/^* //'` && git merge `git branch -l master main | sed 's/^* //'`'
```

### set upstream for a new branch
```sh
function newupstream { git push --set-upstream origin `git rev-parse --abbrev-ref HEAD` } # use this to set upstream for a new branch
```
