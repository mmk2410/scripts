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
        # shellcheck disable=SC2076
        if [[ ! "${installed_apps[*]}" =~ "${app}" ]]; then
            echo "$app not installed. Installing it."
            flatpak install -y "$app"
        fi
    done

    echo "Checking for apps to remove."
    for app in "${installed_apps[@]}"; do
        # shellcheck disable=SC2076
        if [[ ! "${requested_apps_cleaned[*]}" =~ "${app}" ]]; then
            echo "$app no found in apps list. Removing it.";
            flatpak uninstall -y "$app"
        fi
    done
}

function add() {
    local appId="${2:-}"

    if [[ -z "$appId" ]]; then
        echo "No application ID given."
        exit 1
    fi

    if grep "$appId" "$APPS_LIST_PATH"; then
        echo "App already in apps list. Run with sync command to install."
        exit 2
    fi

    local appsListFile
    appsListFile="$(realpath "$APPS_LIST_PATH")"
    echo "$appId" >> "$appsListFile"
}

cmd="${1:-}"

case "$cmd" in
    a|add|i|install )
        add "$@"
        sync
        ;;
    * )
        sync
esac
