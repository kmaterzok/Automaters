#!/bin/bash

# The following script converts a list of attractions
# saved in notation * [ ] [Name](Google Maps point link)
# into a corresponding GPX file.

set -ueo pipefail

if [[ $# -eq 1 && $1 = '--help' ]]; then
  echo "The following script converts a list of attractions"
  echo "saved in notation * [ ] [Name](Google Maps point URL)"
  echo "into a corresponding GPX file."
  echo ""
  echo "Syntax: <script_name> <source_file.md> <destination_file.gpx>"
  exit 0
fi

if [[ $# -ne 2 ]]; then
  echo "You need to pass source file name and destination file name. Run the script with --help flag."
  exit 1
fi

SOURCE_FILE_NAME="$1"
DESTINATION_FILE_NAME="$2"

if [[ ! -e "$SOURCE_FILE_NAME" ]]; then
  echo "File $SOURCE_FILE_NAME does not exist."
  exit 2
fi



# Beginning of the file
cat > "$DESTINATION_FILE_NAME" <<EOF
<?xml version='1.0' encoding='UTF-8' standalone='yes' ?>
<gpx version="1.1" creator="OsmAnd 4.2.7" xmlns="http://www.topografix.com/GPX/1/1" xmlns:osmand="https://osmand.net" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd">
  <metadata>
EOF
echo "    <name>$DESTINATION_FILE_NAME</name>
    <time>$(date --utc +"%Y-%m-%dT%TZ")</time>
  </metadata>" >> "$DESTINATION_FILE_NAME"



# Saving points
MATCHING_REGEX="^\*\ \[\ \]\ \[(.*)\]\((.*)!3d([0-9.]{1,})!4d([0-9.]{1,})(.*)\)$"
while read -r FILE_LINE; do
  if [[ $FILE_LINE =~ $MATCHING_REGEX ]]; then
    ORIGINAL_NAME=`echo ${BASH_REMATCH[1]}`
    VALID_NAME=`echo "${ORIGINAL_NAME//&/&amp;}"`
    echo "  <wpt lat=\"${BASH_REMATCH[3]}\" lon=\"${BASH_REMATCH[4]}\"><name>${VALID_NAME}</name></wpt>" >> "$DESTINATION_FILE_NAME"
  fi
done < "$SOURCE_FILE_NAME"



# End of the file
cat >> "$DESTINATION_FILE_NAME" <<EOF
  <extensions>
    <osmand:points_groups>
      <group name="" color="#eecc22" icon="special_star" background="circle" />
    </osmand:points_groups>
  </extensions>
</gpx>
EOF
