#!/bin/zsh
# Usage: Run this in the vulnrichment git repository, which should share a
# parent path with nvd-json-data-feeds git repository. Something like this:
#
# git clone https://github.com/fkie-cad/nvd-json-data-feeds.git
# git clone https://github.com/cisagov/vulnrichment.git
#
# Then, just run nvd-count.sh from the ./nvd-count/ path, and you're all
# set. If you time it, you'll get around these results:
#
# Processing complete. CSV files created:
#   - ./nvd-awaiting.csv (Line Count: 13002)
#   - ./nvd-analyzed.csv (Line Count: 129439)
#   - ./nvd-modified.csv (Line Count: 95424)
#   - ./nvd-rejected.csv (Line Count: 14209)
#   - ./nvd-other.csv (Line Count: 38)
# real 2497.55
# user 1259.97
# sys 976.48

nvd_dir=../../nvd-json-data-feeds
analyzed_csv=./nvd-analyzed.csv
awaiting_csv=./nvd-awaiting.csv
modified_csv=./nvd-modified.csv
rejected_csv=./nvd-rejected.csv
   other_csv=./nvd-other.csv

echo "CVE,Published,Modified,Status" > $awaiting_csv
echo "CVE,Published,Modified,Status" > $analyzed_csv
echo "CVE,Published,Modified,Status" > $modified_csv
echo "CVE,Published,Modified,Status" > $rejected_csv
echo "CVE,Published,Modified,Status" > $other_csv

echo "[*] Finding all CVE JSON files in $nvd_dir"
find $nvd_dir -type f -name 'CVE-*.json' | while read -r json_file; do

  id=$(jq -r '.id' "$json_file")
  echo "[*] Checking $id"
  published=$(jq -r '.published' "$json_file")
  lastModified=$(jq -r '.lastModified' "$json_file")
  vulnStatus=$(jq -r '.vulnStatus' "$json_file")

  case "$vulnStatus" in
    "Awaiting Analysis")
      echo "$id,$published,$lastModified,$vulnStatus" >> $awaiting_csv
      ;;
    "Analyzed")
      echo "$id,$published,$lastModified,$vulnStatus" >> $analyzed_csv
      ;;
    "Modified")
      echo "$id,$published,$lastModified,$vulnStatus" >> $modified_csv
      ;;
    "Rejected")
      echo "$id,$published,$lastModified,$vulnStatus" >> $rejected_csv
      ;;
    *)
      echo "$id,$published,$lastModified,$vulnStatus" >> $other_csv
      ;;
  esac
done

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

