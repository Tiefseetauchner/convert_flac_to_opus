#!/bin/bash

info() {
    echo "Extract UNSYNCEDLYRICS metadata from audio files and save them as txt files in the same location as the audio file."
    usage
}

usage() {
    echo "usage: extract_lyrics.sh [options]

-d dir    Directory containing the music files
-t list   File types as a comma-separated list, e.g., mp3,flac,opus
-v        Verbose mode (optional)
-h        Show this help"
}

DIRECTORY="."
EXTENSIONS=($(echo "mp3,flac,opus,m4a,wav" | tr ',' '\n'))
VERBOSE=0
SKIP_TEST=0

while getopts "d:t:vyh" opt; do
    case $opt in
        d)
            DIRECTORY=$OPTARG
            ;;
        t)
            EXTENSIONS=($(echo "$OPTARG" | tr ',' '\n'))
            ;;
        v)
            VERBOSE=1
            ;;
        y)
            SKIP_TEST=1
            ;;
        h)
            info
            exit 0
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            exit 1
            ;;
    esac
done

echo "Building Regex..."

# Construct the find command regex pattern for file extensions
regex_pattern=".*\\.\\(${EXTENSIONS[0]}"
for ext in "${EXTENSIONS[@]:1}"; do
    regex_pattern+="\\|${ext}"
done
regex_pattern+="\\)$"

echo "Regex is $regex_pattern"

if [ ! $SKIP_TEST ]; then
    echo "Extracting from $(ls -lR $DIRECTORY | grep "\(${EXTENSIONS[0]}$(if [ ${#EXTENSIONS[@]} -gt 1 ]; then printf -- '\|%s' ${EXTENSIONS[@]:1}; fi)\)$" | wc -l) files. You can start this script with the -y flag to skip this check."
    read -p "Continue? (y/N): " response

    case "$response" in
        [yY])
            echo "Extracting..."
            ;;
        [nN]|"")
            echo "Exiting."
            exit 0
            ;;
        *)
            echo "Invalid input $response. Only Y or N are allowed"
            usage
            exit 1
            ;;
    esac
else
    echo "Converting with $THREADS processes (this might take a while depending on your files, if you have CPU to spare set -t higher, default is 1)"
fi

# Find and process files
find "$DIRECTORY" -type f -iregex "$regex_pattern" -exec bash -c '
    for file; do
        [[ $VERBOSE == 1 ]] && echo "Processing $file"
        lyrics=$(ffprobe -v error -show_entries format_tags=UNSYNCEDLYRICS -of default=noprint_wrappers=1:nokey=1 "$file")
        if [ ! -z "$lyrics" ]; then
            echo "$lyrics" > "${file%.*}.txt"
            echo "Lyrics extracted for $file"
        fi
    done
' bash {} +
