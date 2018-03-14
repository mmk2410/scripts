#!/usr/bin/fish
# Download splitted videos and combine them.
# Created for .ts segments, output is a mp4 file.
# Limited to videos with less than 9999 segments (which should be enought).
#
# 2018 (c) Marcel Kapfer
# MIT License
#
# Run with:
# ./video.fish <number of sequences> <URL before segment number> [URL after segment number]
#
# Requirements:
# - fish (https://fishshell.com)
# - curl (https://curl.haxx.se/)
# - ffmpeg (https://ffmpeg.org/)

set parts_file "./parts.list"
set in_ext ".ts"
set out_ext ".mp4"
set combined_file "./combined"$in_ext
set output_file "./out"$out_ext

function _cleanup
    if test -f $parts_file
	rm $parts_file
    end
    if test -f $output_file
	rm *$in_ext
    end
end

trap _cleanup SIGINT

if test (count $argv) -gt 3
    echo "To much arguments given. Aborting."
    exit 1
end

if test (count $argv) -lt 2
    echo "No sequence number or URL given. Aborting."
    exit 1
end

set num_seq $argv[1]
set url_1 $argv[2]

if test (count $argv) -eq 3
    set url_2 $argv[3]
else
    set -l url_2 ""
end

for segment in (seq $num_seq)
    # padding for the filename
    if test $segment -lt 10
	set file_num "000"$segment
    else if test $segment -lt 100
	set file_num "00"$segment
    else if test $segment -lt 1000
	set file_num "0"$segment
    else
	set file_num $segment
    end

    # download the segments using curl
    curl \
    --output $file_num$in_ext \
    $url_1$segment$url_2

    # add segment file to file list
    echo "file './"$file_num$in_ext"'" >> $parts_file
end

## combine the files
ffmpeg -f concat -safe 0 -i $parts_file -c copy $combined_file

## convert
ffmpeg -i $combined_file -acodec copy -vcodec copy $output_file

_cleanup
