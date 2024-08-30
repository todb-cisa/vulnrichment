#!/bin/zsh
# Usage: This script extracts CWE IDs and CVE IDs from JSON files, concatenating multiple CWE IDs on one line with ";" as a separator, and records them in cve-cwe.txt and cve-no-cwe.txt.

adp_dir=..

cwe_file=./cve-cwe.txt
no_cwe_file=./cve-no-cwe.txt
echo "[*] Initializing output files"
: > $cwe_file # Clear the file before writing new data
: > $no_cwe_file # Clear the file before writing new data

echo "[*] Finding all CVE JSON files in $adp_dir"
find $adp_dir -type f -name 'CVE-*.json' | while read -r json_file; do
  cve_id=$(jq -r '.cveMetadata.cveId' "$json_file")
  cwe_ids=$(jq -r '[.containers.adp[].problemTypes[].descriptions[].cweId] | join(";")' "$json_file" 2>/dev/null)
  
  if [[ -n $cwe_ids ]]; then
    echo "[*] Recording CVE ID and CWE IDs: $cve_id, $cwe_ids"
    echo "$cve_id,$cwe_ids" >> $cwe_file
  else
    echo "$cve_id" >> $no_cwe_file
  fi
done

cwe_lines=$(wc -l < $cwe_file | tr -d ' ')
no_cwe_lines=$(wc -l < $no_cwe_file | tr -d ' ')
echo "Processing complete. Files created:
  - $cwe_file (Line Count: $cwe_lines)
  - $no_cwe_file (Line Count: $no_cwe_lines)"
