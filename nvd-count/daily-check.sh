#!/bin/zsh
# Usage: Run this once a day to get an end-to-end refresh of current
# Vulnrichment vs NVD stats. This assumes you're already in the 
# nvd-counter branch, in the nvd-count subdirectory, and that your
# local git layout is as advised in this subdirectory's README.

git -C ../../nvd-json-data-feeds fetch --all && git -C ../../nvd-json-data-feeds pull -r
git fetch --all
git update-ref refs/head/develop upstream/develop
git push origin develop
git merge develop -m "Merge develop to nvd-counter"

# Record the date in the same format that NVD does
start_date=$(date +"%Y-%m-%dT%H:%M:%S")
milliseconds=$(date +"000") # Milliseconds are for weirdos
formatted_start_date="${start_date}.${milliseconds}"
echo $formatted_date

./nvd-count.sh &&
./adp-count.sh &&
echo -n "As of $formatted_start_date, " &&
./count-complete-and-todo-cves.sh | tee stats.md

analyzed_csv=./nvd-analyzed.csv
awaiting_csv=./nvd-awaiting.csv
modified_csv=./nvd-modified.csv
rejected_csv=./nvd-rejected.csv
   other_csv=./nvd-other.csv

 adp_done_file=./adp-done.txt
adp_extra_file=./adp-extra.txt
 adp_todo_file=./adp-todo.txt

nvd_awaiting_lines=$(wc -l < $awaiting_csv | tr -d ' ')
nvd_analyzed_lines=$(wc -l < $analyzed_csv | tr -d ' ')
nvd_modified_lines=$(wc -l < $modified_csv | tr -d ' ')
nvd_rejected_lines=$(wc -l < $rejected_csv | tr -d ' ')
nvd_other_lines=$(wc -l < $other_csv | tr -d ' ')

adp_done_count=$(wc -l < $adp_done_file | tr -d ' ')
adp_extra_count=$(wc -l < $adp_extra_file | tr -d ' ')
adp_todo_count=$(wc -l < $adp_todo_file | tr -d ' ')

echo "$formatted_start_date,$nvd_awaiting_lines,$nvd_analyzed_lines,$nvd_modified_lines,$nvd_rejected_lines,$nvd_other_lines,$adp_done_count,$adp_extra_count,$adp_todo_count" >> daily-stats.csv

echo "Finished at $(date)"
git add *.csv
git add *.txt
git add *.md
git commit -m "Updating stats"
git push origin



