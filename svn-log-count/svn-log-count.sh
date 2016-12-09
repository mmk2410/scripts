#!/bin/bash

dates=$(svn log | grep "^r" | grep "|" | cut -d'|' -f3 | cut -d' ' -f2)

# get total amount of commits

echo "Sum: $(echo "$dates" | wc -l)"

# get first year

for curyear in $(echo "$dates" | cut -d'-' -f1); do
    if [[ -z $year ]]; then
	year=$curyear
    fi
    if [[  $curyear -lt $year ]]; then
	year=$curyear
    fi
done

echo "First Commit (Year): $year"


# get amount of commits per year

while [[ $year -le $(date +"%Y") ]]; do
    echo "Sum for $year: $(echo "$dates" | grep "^$year" | wc -l)"
    year=$((year+1))
done

