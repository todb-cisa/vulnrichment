#!/bin/zsh
# Usage: This script extracts CWE IDs, CVSS baseScores, and CPE strings from JSON files, writing
# them to respective output files.

adp_dir=..

cwe_file=./cve-cwe.txt
no_cwe_file=./cve-no-cwe.txt

cvss_file=./cve-cvss.txt
no_cvss_file=./cve-no-cvss.txt

cpe_file=./cve-cpe.txt
no_cpe_file_cpe=./cve-no-cpe.txt

# Initialize output files
echo "[*] Initializing output files"
files=($cwe_file $no_cwe_file $cvss_file $no_cvss_file $cpe_file $no_cpe_file_cpe)
for file in "${files[@]}"; do
  : > $file
done

echo "[*] Finding all CVE JSON files in $adp_dir"
find $adp_dir -type f -name 'CVE-*.json' | while read -r json_file; do
  cve_id=$(jq -r '.cveMetadata.cveId' "$json_file")

  # Process CWE IDs
  cwe_ids=$(jq -r '[.containers.adp[].problemTypes[]?.descriptions[]?.cweId] | join(";")' "$json_file" 2>/dev/null)
  if [[ -n $cwe_ids ]]; then
    echo "[*] Recording CVE ID and CWE IDs: $cve_id, $cwe_ids"
    echo "$cve_id,$cwe_ids" >> $cwe_file
  else
    echo "$cve_id" >> $no_cwe_file
  fi

  # Process CVSS baseScore
  base_score=$(jq -r '.containers.adp[].metrics[]?.cvssV3_1.baseScore // empty' "$json_file" 2>/dev/null)
  if [[ -n $base_score ]]; then
    echo "[*] Recording CVE ID and baseScore: $cve_id, $base_score"
    echo "$cve_id,$base_score" >> $cvss_file
  else
    echo "$cve_id" >> $no_cvss_file
  fi

  # Process CPE strings
  cpe_strings=$(jq -r '[.containers.adp[].affected[]?.cpes[]] | join(";")' "$json_file" 2>/dev/null)
  if [[ -n $cpe_strings ]]; then
    echo "[*] Recording CVE ID and CPE strings: $cve_id, $cpe_strings"
    echo "$cve_id,$cpe_strings" >> $cpe_file
  else
    echo "$cve_id" >> $no_cpe_file_cpe
  fi
done

echo "Processing complete. Files created:"
for file in "${files[@]}"; do
  sort -o $file $file
  line_count=$(wc -l < $file | tr -d ' ')
  echo "  - $file (Line Count: $line_count)"
done