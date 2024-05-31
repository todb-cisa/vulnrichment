#!/bin/zsh
# Usage: Usage notes here

adp_dir=..

processed_csv=./adp-processed.csv
echo "CVE" > $processed_csv

echo "[*] Finding all CVE JSON files in $adp_dir"
find $adp_dir -type f -name 'CVE-*.json' | while read -r json_file; do
  id=$(jq -r '.cveMetadata.cveId' "$json_file")
  echo "[*] Recording $id"
  echo $id >> $processed_csv
done

processed_lines=$(wc -l < $processed_csv | tr -d ' ')
echo "Processing complete. CSV files created:
  - $processed_csv (Line Count: $processed_lines)"
