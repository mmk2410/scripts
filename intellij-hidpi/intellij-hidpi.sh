#!/bin/bash
# This is a small script for enabling and disabling HiDPI support on IntelliJ IDEA Community Edition on every Linux distribution where IntelliJ is installed in /usr/share/intellijidea-ce/. If the installation is somewhere else you have to change the variable IDEA_PATH.
# Marcel Michael Kapfer
# 27 May 2015
# GNU GPL v3.0 -> Feel free to re-distribute or fork it

## IntelliJ path
IDEA_PATH="/usr/share/intellijidea-ce/bin"

## Enable HiDPI
function enable_hidpi {
    sudo echo "-Dhidpi=true" >> $IDEA_PATH/idea.vmoptions
    sudo echo "-Dhidpi=true" >> $IDEA_PATH/idea64.vmoptions
    echo "HiDPI enabled"
    exit
}

## Disable HiDPI
function disable_hidpi {
    idea=$(sed '/-Dhidpi=true/d' $IDEA_PATH/idea.vmoptions)
    idea64=$(sed '/-Dhidpi=true/d' $IDEA_PATH/idea64.vmoptions)
    sudo echo "$idea" > $IDEA_PATH/idea.vmoptions
    sudo echo "$idea64" > $IDEA_PATH/idea64.vmoptions
    echo "HiDPI disabled"
    exit
}

## Usage
usage=$(
cat <<EOF
Usage:

Enable HiDPI support:
--enable
or
-e

Disabling HiDPI support:
--disable
or
-d

Help (prints this)
--help
or
-h

EOF
)

## Options
### Runns if no argument is given
if [[ -z "$1" ]]
then
    echo
    echo "$usage"
    exit
fi


### Runs if an argument is given
until [[ $1 == -- ]]; do
    case $1 in
        -e | --enable)
            enable_hidpi
            ;;
        -d | --disable)
            disable_hidpi
            ;;
        -h | --help)
            echo "$usage"
            exit
            ;;
    esac
done
