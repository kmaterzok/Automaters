#!/bin/bash

# NOTICE:
# This script should be automatically executed from
# Task Scheduler or cron.
# The purpose of this script is to synchronise
# repo dirs with the origins (remote repos).

set -ueo pipefail

# set fetching of all repos even if there is a branch with a hash in its name.
FETCH_ALL=0
if [ $# -eq 1 ] && [ "$1" = '--fetch-all' ]; then FETCH_ALL=1; fi


# main path to the dirs containing all repos
PATH_TO_REPOS='/home/myuser/Documents/Repos'
# path for logging
LOGGING_PATH='/home/myuser/Documents/Repos/km-rpupd.log'
# checked branches separated by | character
UPDATED_BRANCHES='develop|release|hotfix|master'


echo "Sync start at: $(date)" >> "${LOGGING_PATH}"
# go to dir with repos
cd "$PATH_TO_REPOS" || ( echo "fatal: Reporitory path invalid!" && exit 1 )
# names of repo dirs
REPO_DIRS=$(for i in *; do [ -d "$i" ] && echo "$i"; done)


IFS=$'\n'
for SG_REPO_DIR in $REPO_DIRS; do

	# remove trailing slash from name
	SG_REPO_DIR="$(echo "$SG_REPO_DIR" | tr -d '/')"
	# go to folder with repo
	cd "${PATH_TO_REPOS}/${SG_REPO_DIR}" || ( echo "fatal: Cannot switch to another repository!" && exit 1 )

	# ignore dirs withotut .git directory
	if [[ ! -d './.git' ]] ; then
		continue
	fi

	# info about current folder
	echo -e "\033[1;31;31m      UPDATING   ${SG_REPO_DIR}\033[0m"

	# get name of currently checked out branch
	CURRENT_USER_BRANCH=$(git rev-parse --abbrev-ref HEAD)

	# ignore if current branch name contains with hash character
	if [[ ${FETCH_ALL} -eq 0 ]] && [[ $CURRENT_USER_BRANCH = *\#* ]]; then
		echo "info: Ignored because of ${CURRENT_USER_BRANCH} branch."
		continue
	fi

	# get commits and update repository
	git fetch --prune

	# update defined branches
	IFS=$'|'
	for SG_BRANCH_NAME in $UPDATED_BRANCHES; do
		if git show-branch | grep -q "\[$SG_BRANCH_NAME\]"
		then
			git checkout "$SG_BRANCH_NAME"
			git pull
		fi
	done

	# come back to the memorised branch
	git checkout "$CURRENT_USER_BRANCH"
done

echo -e "\033[1;31;31mSync finish at: $(date)\033[0m"
echo "Sync finish at: $(date)" >> "${LOGGING_PATH}"

