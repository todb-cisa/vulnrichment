#!/bin/zsh
# Usage: This script extracts the "baseScore" and CVE ID from JSON files and records them in cve-basescores.txt and cve-no-cvss.txt

adp_dir=..

cvss_file=./cve-cvss.txt
no_cvss_file=./cve-no-cvss.txt
echo "[*] Initializing output files"
: > $cvss_file # Clear the file before writing new data
: > $no_cvss_file # Clear the file before writing new data

echo "[*] Finding all CVE JSON files in $adp_dir"
find $adp_dir -type f -name 'CVE-*.json' | while read -r json_file; do
  cve_id=$(jq -r '.cveMetadata.cveId' "$json_file")
  base_score=$(jq -r '.containers.adp[].metrics[].cvssV3_1.baseScore // empty' "$json_file" 2>/dev/null)
  
  if [[ -n $base_score ]]; then
    echo "[*] Recording CVE ID and baseScore: $cve_id, $base_score"
    echo "$cve_id,$base_score" >> $cvss_file
  else
    echo "$cve_id" >> $no_cvss_file
  fi
done

output_lines=$(wc -l < $cvss_file | tr -d ' ')
no_cvss_lines=$(wc -l < $no_cvss_file | tr -d ' ')
echo "Processing complete. Files created:
  - $cvss_file (Line Count: $output_lines)
  - $no_cvss_file (Line Count: $no_cvss_lines)"
