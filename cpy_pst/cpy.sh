#!/bin/bash

# This is a small script for copy pasting files and directories.
#
# Marcel Kapfer (mmk2410) <marcelmichaelkapfer@yahoo.co.nz>
#
# 15 August 2015
#
# GNU GPL v3
#
# Version: 0.1 -> feel free to redistribute or fork it

FILE=/tmp/cpypst

function copy {
    if [[ -d "$FILE" ]]; then
        rm -rf $FILE
    elif [[ -f "$FILE" ]]; then
        rm $FILE
    fi
    if [[ -d "$1" ]]; then
        cp -R $1 $FILE
    elif [[ -f "$1" ]]; then
        cp $1 $FILE
    fi
}

usage=$(
cat<<EOF
COPY AND PASTE
for the terminal

Usage: cpy args

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
    copy $1
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
