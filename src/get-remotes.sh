#!/bin/bash

# NOTICE:
# This script should be executed manually as it may run not fast enough.
# The purpose of this script is to synchronise existence
# of branches with those ones present in the origin.

set -ueo pipefail

# main path to the dirs containing all repos
PATH_TO_REPOS='/home/myuser/Documents/Repos'

# go to dir with repos
cd "$PATH_TO_REPOS"

# names of repo dirs
REPO_DIRS=$(for i in *; do [ -d "$i" ] && echo "$i"; done)

IFS=$'\n'
for SG_REPO_DIR in $REPO_DIRS; do

	# remove trailing slash from name
	SG_REPO_DIR="$(echo "$SG_REPO_DIR" | tr -d '/')"

	# go to folder with repo
	cd "${PATH_TO_REPOS}/${SG_REPO_DIR}"

	# ignore dirs withotut .git directory
	if [[ ! -d './.git' ]]; then
		continue
	fi

	# info about current folder
	echo -e "\033[1;31;31m$(date) : Pruning origin of ${SG_REPO_DIR}\033[0m"

	# get commits and update repository
	git remote update origin --prune
done

echo -e "\033[1;31;31m$(date) : Finished\033[0m"
