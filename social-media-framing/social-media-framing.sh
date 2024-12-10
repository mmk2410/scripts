#!/usr/bin/env bash

set -euo pipefail

INFO="\033[0;30m\033[47m"
START="\033[0;30m\033[44m"
DONE="\033[0;30m\033[42m"
ERROR="\033[0;30m\033[41m"
NC="\033[0m"

log_info() {
    echo -e "${INFO} INFO ${NC} $1"
}

log_start() {
    echo -e "${START} START ${NC} $1"
}

log_done() {
    echo -e "${DONE} DONE ${NC} $1"
}

log_error() {
    echo -e "${ERROR} ERROR ${NC} $1"
}

log_info "Welcome to the social media framing script."
log_info "We're using the power of imagemagick and exiftool"

set +u
if [[ -z "$1" ]]; then
    log_error "Missing filename argument."
    exit 1
fi
set -u

if [[ ! -f "$1" ]]; then
    log_error "File with filename $1 not found."
    exit 1
fi

filename="$(basename "$1")"
extension="${filename##*.}"
path="$(dirname "$1")/${filename%%.*}"

regular="$path""-regular.""$extension"
square="$path""-square.""$extension"
story="$path""-story.""$extension"

if [[ ! -f "$regular" ]]; then
    log_start "Creating regular framing"
    magick "$1" -resize "1920x1920>" "$regular"
    log_start "Fixing EXIF metadata"
    exiftool -q -tagsFromFile "$1" "$regular"
fi

if [[ ! -f "$square" ]]; then
    log_start "Creating square framing"
    magick -define jpeg:size=1920x1920 "$1" \
           -thumbnail '1890x1890' \
           -gravity center \
           -crop 1920x1920+0+0\! \
           -flatten \
           "$square"
    log_start "Fixing EXIF metadata"
    exiftool -q -tagsFromFile "$1" "$square"
fi

if [[ ! -f "$story" ]]; then
    log_start "Creating story framing"
    magick -define jpeg:size=1080x1920 "$1" \
           -thumbnail '1050x1890' \
           -gravity center \
           -crop 1080x1920+0+0\! \
           -flatten \
           "$story"
    log_start "Fixing EXIF metadata"
    exiftool -q -tagsFromFile "$1" "$story"
fi

exiftool -q -delete_original! "$(dirname "$1")"
log_done "Finished creating framed images"
