#!/usr/bin/env bash
#
# flatpak-sync is an easy approach for declaring the installed flatpak apps.
#
# 2023 (c) Marcel Kapfer <opensource@mmk2410.org>
# Licensed under the MIT License

set -euo pipefail

APPS_LIST_PATH="${APPS_LIST_PATH:=$HOME/.config/flatpak-sync/apps.list}"

APP_NAME="flatpak-sync"
APP_COLOR="\033[0;35m"
INFO_COLOR="\033[0;32m"
ERR_COLOR="\033[1;31m"
NO_COLOR="\033[0m"

info() {
    printf "$APP_COLOR[$APP_NAME] $INFO_COLOR$1$NO_COLOR\n"
}

error() {
    printf "$APP_COLOR[$APP_NAME] $ERR_COLOR$1$NO_COLOR\n"
}

usage() {
    info "Usage:"
    info " -l  Path to the file keeping the date of the last check."
    info " -r  Path to the directory containing all org-roam files."
    info " -b  Path to the hugo base directory."
    info " -s  Path of the Emacs lisp script for exporting the org-roam files."
}

function sync() {
    readarray -t requested_apps < <(cat "$APPS_LIST_PATH")
    readarray -t installed_apps < <(flatpak list --app --columns app | tail -n +1)

    declare -a requested_apps_cleaned=()

    info "Checking for apps to install."
    for app in "${requested_apps[@]}"; do
        if [[ -z "$app" ]] || [[ "$app" =~ ^#.* ]]; then
            continue
        fi
        requested_apps_cleaned+=("$app")
        # shellcheck disable=SC2076
        if [[ ! "${installed_apps[*]}" =~ "${app}" ]]; then
            info "$app not installed. Installing it."
            flatpak install -y "$app"
        fi
    done

    info "Checking for apps to remove."
    for app in "${installed_apps[@]}"; do
        # shellcheck disable=SC2076
        if [[ ! "${requested_apps_cleaned[*]}" =~ "${app}" ]]; then
            info "$app no found in apps list. Removing it.";
            flatpak uninstall -y "$app"
        fi
    done
}

function add() {
    local appId="${2:-}"

    if [[ -z "$appId" ]]; then
        error "No application ID given."
        usage
        exit 1
    fi

    if grep -q "# $appId" "$APPS_LIST_PATH"; then
        error "App $appId already in apps list but commented out."
        error "Manual fix of the app list file necessary."
        exit 2
    fi

    if grep -q "$appId" "$APPS_LIST_PATH"; then
        error "App $appId already in apps list."
        error "Run sync command to install it."
        usage
        exit 3
    fi

    info "Adding app $appId to apps list and installing it."
    local appsListFile
    appsListFile="$(realpath "$APPS_LIST_PATH")"
    echo "$appId" >> "$appsListFile"
}

function remove() {
    local appId="${2:-}"

    if [[ -z "$appId" ]]; then
        error "No application ID given."
        usage
        exit 1
    fi

    if grep -q "# $appId" "$APPS_LIST_PATH"; then
        error "App $appId already in apps list but commented out."
        error "No remove possible."
        exit 2
    fi

    if ! grep -q "$appId" "$APPS_LIST_PATH"; then
        error "App $appId not in apps list."
        usage
        exit 2
    fi

    info "Removing app $appId from apps list and uninstalling it."
    local appsListFile
    appsListFile="$(realpath "$APPS_LIST_PATH")"
    appsListTmpFile="$(mktemp)"
    grep -v "$appId" "$APPS_LIST_PATH" >> "$appsListTmpFile"
    mv "$appsListTmpFile" "$appsListFile"
}

cmd="${1:-}"

case "$cmd" in
    a|add|i|install )
        add "$@"
        sync
        ;;
    r|remove|u|uninstall )
        remove "$@"
        sync
        ;;
    * )
        sync
esac
