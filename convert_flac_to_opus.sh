#!/bin/bash

info() {
    echo "Convert audio files in directory to opus streams while maintaining metadata
Finds files recursively"

    usage
}

usage() {
    echo "usage: convert_flac_to_opus.sh [options]

-e list   Extensions to convert as comma seperated list
          Default: .flac
-d dir    Directory to search
          Default: .
-t num    Number of ffmpeg processes started concurrently
          Default: 1
-r        Removes old files after conversion
-y        Skip verification
-h        Show this help"
}

THREADS=1
EXTENSIONS=(".flac")
DIRECTORY="."

while getopts "e:d:yt:rh" opt; do
    case $opt in
        e)
            EXTENSIONS=($(echo "$OPTARG" | tr ',' '\n'))
            ;;
        d)
            DIRECTORY=$OPTARG
            ;;
        y)
            SKIP_TEST=YES
            ;;
        t)
            THREADS=$OPTARG
            ;;
        r)
            REMOVE=YES
            ;;
        h)
            info
            exit 0
            ;;
        \?)
            echo "Use -h for help"
            exit 1
            ;;
    esac
done

if [ ! -e "$DIRECTORY" ]; then
    echo "convert_flac_to_opus: no such file or directory: $DIRECTORY"
    exit 1
fi

if [ ! $SKIP_TEST ]; then
    echo "Converting $(ls -lR $DIRECTORY | grep "\(${EXTENSIONS[0]}$(if [ ${#EXTENSIONS[@]} -gt 1 ]; then printf -- '\|%s' ${EXTENSIONS[@]:1}; fi)\)$" | wc -l) files. You can start this script with the -y flag to skip this check."
    read -p "Continue? (y/N): " response

    case "$response" in
        [yY])
            echo "Converting with $THREADS processes (this might take a while depending on your files, if you have CPU to spare set -t higher, default is 1)"
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

find $DIRECTORY -type f \( -iname "*${EXTENSIONS[0]}" $(if [ ${#EXTENSIONS[@]} -gt 1 ]; then printf -- '-o -iname *%s ' "${EXTENSIONS[@]:1}"; fi) \) -print0 | xargs -0 -P $THREADS -I {} ffmpeg -i "{}" -codec:a libopus "{}.opus"

if [ $REMOVE ]; then
    find $DIRECTORY -type f \( -iname "*${EXTENSIONS[0]}" $(if [ ${#EXTENSIONS[@]} -gt 1 ]; then printf -- '-o -iname *%s ' "${EXTENSIONS[@]:1}"; fi) \) -exec rm {} \;
fi
