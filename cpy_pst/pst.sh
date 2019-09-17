#!/bin/bash

# A small script for copy pasting files and directories.
#
# Marcel Kapfer (mmk2410) <opensource@mmk2410.org>
#
# 15 August 2015
#
# GNU GPL v3 -> feel free to re-distribute of fork it
#
# Version: 0.1

FILE=/tmp/cpypst

function paste {
    if [[ -d "$FILE" ]]; then
        cp -R "$FILE" "$1"
    elif [[ -f "$FILE" ]]; then
        cp $FILE $1
    fi
}


usage=$(
cat<<EOF
COPY AND PASTE
for the terminal

Usage: pst filename

   -h | --help          Prints this help text

mmk2410
marcel-kapfer.de
EOF
)

if [[ -z "$1" ]]; then
    echo
    echo "$usage"
    echo
    exit
elif [[ -z "$2" ]]; then
    paste $1
else
    until [[ $1 == -- ]]; do
        case $1 in
            -h | --help )
                echo
                echo "$usage"
                echo
                exit
                ;;
        esac
    done
fi
