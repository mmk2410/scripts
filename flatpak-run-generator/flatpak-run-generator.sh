#!/usr/bin/bash
### Flatpak launcher script generator.
###
### Description: Create shell scripts for launching flatpak apps in
### the users bin directory (~/.local/bin). For successful usage it is
### recommended to add this directory to the $PATH variable.
###
### For users not liking this script or who want to get rid all
### created scripts for some other reasons it is possible to run the
### following command inside the ~/.local/bin folder.
###
### cd ~/.local/bin && grep -rl flatpak | xargs rm
###
### 2021 (c) Marcel Kapfer (mmk2410) <opensource@mmk2410.org>
### Licensed under the MIT license

# Add a little bit of security to the script.
set -euf -o pipefail

###
# The directory where the scripts should be put.
###
SCRIPTS_DIR="/home/$USER/.local/bin/"

###
# Helper function for printing an error and exiting.
#
# Uses the first given argument as an error message and prints it.
# Then exits with status code 1.
#
# Params:
#   error message:
#     the error message to print
###
err()
{
    echo "[ERROR] $1"
    exit 1
}

###
# Checks if flatpak is installed on the system.
###
has_flatpak()
{
    if ! type "flatpak" &> /dev/null
    then
        err "Flatpak not installed."
    fi
}

###
# Checks if the $SCRIP_DIR directory exists
###
has_scripts_dir()
{
    if ! [[ -d "$SCRIPTS_DIR" ]]
    then
        err "Directory $SCRIPTS_DIR does not exist. Please create it and run again."
    fi
}

###
# Print warning if a script is not executable.
#
# Used to warn the user in case a script with the name already exists
# in the $SCRIPTS_DIR but is not marked as executable.
#
# Params:
#   app name:
#     The name must by formatted as can be seen in the main function.
#     E.g. instead of “Some App” the correct argument would be “some-app”.
###
is_executable()
{
    local app="$1"
    if ! [[ -x "$SCRIPTS_DIR$app" ]]
    then
        echo "[WARNING] Script for $app already exists, but is not executable."
    fi
}

###
# Create a flatpak launch script.
#
# Uses the argument as a flatpak name to create a script for launching it.
#
# Params:
#   app name:
#     The name must by formatted as can be seen in the main function.
#     E.g. instead of “Some App” the correct argument would be “some-app”.
###
create_script()
{

    local app="$1"
    echo "Creating script for $app"
    # The -i argument for grep is important since otherwise it would
    # not match. It is also not possible to lowercase the query as
    # done in the query in main() since then the application ids would
    # also be lowercased and flatpak application ids are case
    # sensitive.
    local app_id
    app_id="$(flatpak list --app --columns=name,application | tr " " "-" | grep -i "$app" | cut -f2)"
    echo -e "#!/bin/sh\n# Created with https://git.mmk2410.org/mmk2410/scripts/src/branch/main/flatpak-run-generator\nflatpak run $app_id" > "$SCRIPTS_DIR$app"
    chmod +x "$SCRIPTS_DIR$app"
}

####
# Main function of the script
#
# Iterates over the list of installed flatpak apps and calls
# create_script() to create the script if a launcher file for the app
# does not already exists. If a launcher file already exists it is
# checked weather this is executable with is_executable() to warn the
# user.
####
main()
{
    # Check if the flatpak command is available and exit otherwise.
    has_flatpak
    # Check if $SCRIPTS_DIR is available and exit otherwise.
    has_scripts_dir

    # The flatpak query not only returns the app name for looping over
    # them but we also change the names to use them as a script name
    # by lowercasing them and replacing spaces in the name with a
    # dash.
    for app in $(flatpak list --app --columns=name | tr "[:upper:]" "[:lower:]" | tr " " "-")
    do
        if ! [[ -f "$SCRIPTS_DIR/$app" ]]
        then
            create_script "$app"
        else
            is_executable "$app"
        fi
    done
}

# Don't pass any arguments to main, since they are not used.
main
