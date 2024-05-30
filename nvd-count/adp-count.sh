#!/bin/zsh
# Usage: Usage notes here

adp_dir=..

analyzed_csv=./adp-analyzed.csv
echo "CVE" > $analyzed_csv

echo "[*] Finding all CVE JSON files in $adp_dir"
find $adp_dir -type f -name 'CVE-*.json' | while read -r json_file; do
  id=$(jq -r '.cveMetadata.cveId' "$json_file")
  echo "[*] Recording $id"
  echo $id >> $analyzed_csv
done

analyzed_lines=$(wc -l < $analyzed_csv | tr -d ' ')
echo "Processing complete. CSV files created:
  - $analyzed_csv (Line Count: $analyzed_lines)"
