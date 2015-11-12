#!/bin/bash
# A script for automatically creating PDf files from a latex document
# You can set the amounts of builds and the time between these builds
# Usage: ./buildpdf.sh filename [build amount] [time between builds in s]
# Marcel Michael Kapfer
# 6th January 2015
# GNU GPL v3.0 -> Feel free to re-distribute it or fork it
if [[ -z "$1" ]]; then
	echo "Usage: ./buildpdf.sh filename [build amount] [time between builds in s]"
	exit 1
else
	filename=$1
fi	
if [[ -z "$2" ]]; then
	builds=1
else
	builds=$2
fi
if [[ -z "$3" ]]; then
	sleeptime=120
else
	sleeptime=$3
fi
for ((i=1; i<=$builds; ++i)) ;
do
	pdflatex $filename
	echo "Build $i ready"
	if (( i < builds )); then
		echo "Waiting $sleeptime seconds - then build again"
		sleep $sleeptime
	fi
done
