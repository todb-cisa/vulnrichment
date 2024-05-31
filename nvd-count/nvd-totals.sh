#!/bin/zsh
# Usage: Run this in the vulnrichment git repository to count
# up all the lines in the generated CSVs.

nvd_dir=../../nvd-json-data-feeds
awaiting_csv=./nvd-awaiting.csv
analyzed_csv=./nvd-analyzed.csv
modified_csv=./nvd-modified.csv
rejected_csv=./nvd-rejected.csv
other_csv=./nvd-other.csv

awaiting_lines=$(wc -l < $awaiting_csv | tr -d ' ')
analyzed_lines=$(wc -l < $analyzed_csv | tr -d ' ')
modified_lines=$(wc -l < $modified_csv | tr -d ' ')
rejected_lines=$(wc -l < $rejected_csv | tr -d ' ')
other_lines=$(wc -l < $other_csv | tr -d ' ')

echo "Processing complete. CSV files created:
  - $awaiting_csv (Line Count: $awaiting_lines)
  - $analyzed_csv (Line Count: $analyzed_lines)
  - $modified_csv (Line Count: $modified_lines)
  - $rejected_csv (Line Count: $rejected_lines)
  - $other_csv (Line Count: $other_lines)"

