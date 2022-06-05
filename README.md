# About
This is a collection of scripts used for automating some tiresome stuff, especially using _cron_, _systemd_ timers, _Windows Task Scheduler_ or similar tools.

These scripts are described below:


# Available scripts

## [get-remotes.sh](src/get-remotes.sh)
It fetches data from origin for all the repositories in a directory defined within this script.

Important variables:

* ```PATH_TO_REPOS``` - a path to the directory that contains desired repositories.

To execute, run the following command under compliant shell:

```
./get-remotes.sh
```


## [repos-update.sh](src/repos-update.sh)
It fetches commits for specific branches and pulls them automatically for all the repositories within a defined directory. Non-existent branches are ignored.

Important variables:

* ```PATH_TO_REPOS``` - A path to the directory that contains desired repositories.
* ```LOGGING_PATH``` - A path to the log file.
* ```UPDATED_BRANCHES``` - Checked branches separated by ```|``` character.

To execute, run one of the following commands under compliant shell:

* ```./repos-update.sh``` - Casual run. If a repository is done a checkout on a task-specific branch (name with _#_ character) the repository is ignored.
* ```./repos-update.sh --fetch-all``` - Update all repositories, even if a task-specific branch is currently in use.


# Development & notes

* All _bash_ scripts have been declared ```set -ueo pipefail``` clause, so erroneous situations are prevented during execution.
* All the shell scripts are checked for bugs and misuses with usage of [Shellcheck](https://www.shellcheck.net/).
* All the scripts are _bash_-compliant - they can be run under any operating system that has installed _bash_ support.
* It is possible to run the scripts under other shells like _sh_ or _zsh_ with adjusted shebang. Nonetheless, there is no certainty their execution will go off identically as under _bash_.
