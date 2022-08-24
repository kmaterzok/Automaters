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


## [gmaps-points-to-osmand-gpx.sh](src/gmaps-points-to-osmand-gpx.sh)
It converts a list of attractions saved in notation ```* [ ] [Name](Google Maps point URL)``` into a corresponding GPX file.

Sample input file line written in MarkDown:

```
* [ ] [Letenské sady](https://www.google.com/maps/place/Letensk%C3%A9+sady/@50.0939387,14.4176668,16z/data=!4m5!3m4!1s0x470b94c41d2ba9e1:0xe8e8f97c360eadf6!8m2!3d50.09653!4d14.4275399)
```

To execute, run the following command under compliant shell:

```
./gmaps-points-to-osmand-gpx.sh input_file.md output_file.gpx
```

* ```input_file.md``` - input file containing adequate content in markdown. Note: Only lines with links are parsed.
* ```output_file.gpx``` - output file saved as GPX file for importing into Osmand app.


## [mass-wav-to-flac.sh](src/mass-wav-to-flac.sh)

It converts WAV files into FLAC files and moves metadata to their new counterparts.

**Important:** This tool requires _kid3-cli_ and _flac_ installed in your system.

To execute, run the following command under compliant shell:
```
./mass-wav-to-flac.sh
```


## [repos-update.sh](src/repos-update.sh)
It fetches commits for specific branches and pulls them automatically for all the repositories within a defined directory. Non-existent branches are ignored.

![A GIF showing repos-update.sh in action.](imgs/repos-update.gif)

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
