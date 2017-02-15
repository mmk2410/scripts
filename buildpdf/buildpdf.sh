#!/bin/bash
# A script for automatically creating PDf files from a latex document
# You can set the amounts of builds and the time between these builds
# Usage: ./buildpdf.sh filename [build amount] [time between builds in s]
# Marcel Michael Kapfer (mmk2410)
# 6th January 2015 - 2017
# GNU GPL v3.0 -> Feel free to re-distribute it or fork it

print() {

    local text="$1"

    date "+[%F %T] $text"
}

run() {

    local filename="$1"
    local number="$2"

    pdflatex "$filename" > /dev/null 2>&1
    print "Build $number ready"
    
}


build() {

    local filename="$1"
    local builds="$2"
    local sleeptime="$3"
    local i="1"

    while [[ "$i" -le "$builds" ]]; do

	run "$filename" "$i"

	if [[ "$i" -lt "$builds" ]]; then
	    print "Waiting $sleeptime seconds - then build again"
	    sleep "$sleeptime"
	else
	    print "Jobs done. Exiting now..."
	fi

	((++i))

    done

}

build_infty() {

    local filename="$1"
    local builds="1"
    local sleeptime="$2"

    while : ; do

	run "$filename" "$builds"

	print "Waiting $sleeptime seconds - then build again"
	sleep "$sleeptime"

	((++builds))

    done

}

main() {

    if [[ -z "$1" || "$1" == "--help" || "$1" == "-h" ]]; then
	cat <<EOF
Usage: buildpdf.sh filename [build amount] [sleep time]

Options:
  build amount: how many times the pdf should be created.
    Leave empty or set to '0' for infinity builds.

  sleep time: time in seconds between the builds.
    Leave empty will create the pdf every 120 seconds.
EOF
	exit
    else
	filename="$1"
    fi	

    if [[ -z "$2" ]]; then
	builds=0
    else
	builds="$2"
    fi

    if [[ -z "$3" ]]; then
	sleeptime=120
    else
	sleeptime="$3"
    fi

    if [[ "$builds" == 0 ]]; then
	build_infty "$filename" "$sleeptime"
    else
	build "$filename" "$builds"  "$sleeptime"
    fi

}

main "$@"
