#!/bin/bash

# This script is intended to convert WAV files into FLAC files
# and move metadata to their new counterparts.
# This tool requires kid3-cli and flac installed in your system.

set -ueo pipefail

# Check availability of dependencies
! command -v flac &> /dev/null     && echo "error: flac not found!"     && exit 1;
! command -v kid3-cli &> /dev/null && echo "error: kid3-cli not found!" && exit 1;


# All files to convert
SRC_WAV_FILENAMES=$(for i in *.wav; do echo "$i"; done)


IFS=$'\n'
for SRC_WAV_FILENAME in $SRC_WAV_FILENAMES; do
    if [[ "$SRC_WAV_FILENAME" =~ ^(.*)\.wav$ ]]; then

        # Working destination names
        NAME_WITHOUT_EXTENSIONS="${BASH_REMATCH[1]}"
        DST_FLAC_FILENAME="$NAME_WITHOUT_EXTENSIONS.flac"

        echo "Converting $SRC_WAV_FILENAME into $DST_FLAC_FILENAME:"

        echo -n "Transcoding  ..."
        flac -s "$SRC_WAV_FILENAME" -o "$DST_FLAC_FILENAME"
        echo " done"

        echo -n "Copying tags ..."
        kid3-cli -c "select \"""$SRC_WAV_FILENAME""\"" -c copy -c "select \"""$DST_FLAC_FILENAME""\"" -c paste
        echo " done"
    fi
done
