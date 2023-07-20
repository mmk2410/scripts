#!/usr/bin/env bash
#
# flatpak-sync is an easy approach for declaring the installed flatpak apps.
#
# 2023 (c) Marcel Kapfer <opensource@mmk2410.org>
# Licensed under the MIT License

set -euo pipefail

APPS_LIST_PATH="${APPS_LIST_PATH:=$HOME/.config/flatpak-sync/apps.list}"

function sync() {
    readarray -t requested_apps < <(cat "$APPS_LIST_PATH")
    readarray -t installed_apps < <(flatpak list --app --columns app | tail -n +1)

    declare -a requested_apps_cleaned=()

    echo "Checking for apps to install."
    for app in "${requested_apps[@]}"; do
        if [[ -z "$app" ]] || [[ "$app" =~ ^#.* ]]; then
            continue
        fi
        requested_apps_cleaned+=("$app")
        if [[ ! "${installed_apps[*]}" =~ "${app}" ]]; then
            echo "$app not installed. Installing it."
            flatpak install -y "$app"
        fi
    done

    echo "Checking for apps to remove."
    for app in "${installed_apps[@]}"; do
        if [[ ! "${requested_apps_cleaned[*]}" =~ "${app}" ]]; then
            echo "$app no found in apps list. Removing it.";
            flatpak uninstall -y "$app"
        fi
    done
}

sync
