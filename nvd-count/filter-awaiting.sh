#!/bin/zsh
# Usage: A mechanism to filter the results of nvd-count.sh output
# of those CVEs awaiting analysis after some arbitrary date.

checkdate="2024-05-08"

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

input_file="$1"

if [[ ! -f $input_file ]]; then
    echo "Error: Input file '$input_file' does not exist."
    exit 2
fi

head -1 $input_file > nvd-since-$checkdate.csv
head -1 $input_file > nvd-before-$checkdate.csv
echo "Checking those awaiting analysis since $checkdate"

while IFS=, read -r cve published last_modified state; do
    if [[ $cve != *CVE-* ]]; then
        continue
    fi

    published_timestamp=$(date -jf "%Y-%m-%dT%H:%M:%S" "$published" +%s 2>/dev/null)
    check_timestamp=$(date -jf "%Y-%m-%d" $checkdate +%s 2>/dev/null)
    
    if [[ $published_timestamp -gt $check_timestamp ]]; then
        echo "$cve,$published,$last_modified,$state" >> nvd-since-$checkdate.csv
    else
        echo "$cve,$published,$last_modified,$state" >> nvd-before-$checkdate.csv
    fi
done < "$input_file"

since_lines=$(wc -l < nvd-since-$checkdate.csv | tr -d ' ')
before_lines=$(wc -l < nvd-before-$checkdate.csv | tr -d ' ')

echo "Processing complete. CSV files created:
  - nvd-since-$checkdate.csv (Line Count: $since_lines)
  - nvd-before-$checkdate.csv (Line Count: $before_lines)"
