#!/bin/zsh
# Usage: This script extracts CPE strings and CVE IDs from JSON files, concatenating multiple CPE strings on one line with ";" as a separator, and records them in cve-cpe.txt and cve-no-cpe.txt.

adp_dir=..

cpe_file=./cve-cpe.txt
no_cpe_file=./cve-no-cpe.txt
echo "[*] Initializing output files"
: > $cpe_file # Clear the file before writing new data
: > $no_cpe_file # Clear the file before writing new data

echo "[*] Finding all CVE JSON files in $adp_dir"
find $adp_dir -type f -name 'CVE-*.json' | while read -r json_file; do
  cve_id=$(jq -r '.cveMetadata.cveId' "$json_file")
  cpe_strings=$(jq -r '[.containers.adp[].affected[]?.cpes[]] | join(";")' "$json_file" 2>/dev/null)
  
  if [[ -n $cpe_strings ]]; then
    echo "[*] Recording CVE ID and CPE strings: $cve_id, $cpe_strings"
    echo "$cve_id,$cpe_strings" >> $cpe_file
  else
    echo "$cve_id" >> $no_cpe_file
  fi
done

cpe_lines=$(wc -l < $cpe_file | tr -d ' ')
no_cpe_lines=$(wc -l < $no_cpe_file | tr -d ' ')
echo "Processing complete. Files created:
  - $cpe_file (Line Count: $cpe_lines)
  - $no_cpe_file (Line Count: $no_cpe_lines)"
