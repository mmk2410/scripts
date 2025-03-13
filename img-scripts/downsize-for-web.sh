#!/usr/bin/env bash

set -euo pipefail

BOLD="\033[1m"
INFO="\033[0;30m\033[47m"
WORK="\033[0;30m\033[44m"
DONE="\033[0;30m\033[42m"
FAIL="\033[0;30m\033[41m"
NC="\033[0m"

log_info() {
    echo -e "${INFO} INFO ${NC} $1"
}

log_work() {
    echo -e "${WORK} WORK ${NC} $1"
}

log_done() {
    echo -e "${DONE} DONE ${NC} $1"
}

log_fail() {
    echo -e "${FAIL} FAIL ${NC} $1"
}

log_info "Welcome to the ${BOLD}downsize-for-web${NC} script."
log_info "We're using the power of ${BOLD}imagemagick${NC} and ${BOLD}exiftool${NC}."

set +u
if [[ -z "$1" ]]; then
    log_fail "Missing filename argument."
    exit 1
fi
set -u

if [[ ! -f "$1" ]]; then
    log_fail "File with filename $1 not found."
    exit 1
fi

filename="$(basename "$1")"
path="$(dirname "$1")/${filename%%.*}"
output="$path""-web.webp"

if [[ -f "$output" ]]; then
    log_done "A downsized image is already available."
    exit
fi

log_work "Downsizing image…"
convert "$1" -resize "1920x1920>" -define webp:target-size=350000 "$output"

log_work "Fixing EXIF metadata"
exiftool -q -tagsFromFile "$1" "$output"

exiftool -q -delete_original! "$(dirname "$1")"
log_done "Finished creating downsized web image."
