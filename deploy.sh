#!/bin/bash
git stash --all
git checkout master
CURRENT_BRANCH = git branch | grep \* | cut -d ' ' -f2
echo Current branch: $CURRENT_BRANCH
git push -f deploy master
