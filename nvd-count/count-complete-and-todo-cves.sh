#!/bin/zsh

adp_processed_file="adp-processed.csv"
nvd_awaiting_file="nvd-awaiting.csv"
adp_todo_file="adp-todo.txt" # CVEs that are NVD Awaiting Analysis that are not covered by ADP
adp_done_file="adp-done.txt" # CVEs that are NVD Awaiting Analysis that are covered by ADP
adp_extra_file="adp-extra.txt" # CVEs that are NOT in "Awaiting Analysis" state, but are covered by ADP

adp_cves=$(tail -n +2 "$adp_processed_file" | cut -d ',' -f 1 | sort)
nvd_cves=$(tail -n +2 "$nvd_awaiting_file" | cut -d ',' -f 1 | sort)

comm -13 <(echo "$adp_cves") <(echo "$nvd_cves") > "$adp_todo_file"
comm -12 <(echo "$adp_cves") <(echo "$nvd_cves") > "$adp_done_file"
comm -23 <(echo "$adp_cves") <(echo "$nvd_cves") > "$adp_extra_file"

adp_todo_count=$(wc -l < "$adp_todo_file" | tr -d ' ')
adp_done_count=$(wc -l < "$adp_done_file" | tr -d ' ')
adp_extra_count=$(wc -l < "$adp_extra_file" | tr -d ' ')

total_count=$((adp_todo_count + adp_done_count + adp_extra_count))
target_count=$((adp_todo_count + adp_done_count))


percentage_done=$((adp_done_count * 100 / target_count))

echo "$(date)\n"
echo "NVD has $target_count CVEs marked as Awaiting Analysis.\n"
echo "Vulnrichment has covered $adp_done_count CVEs that have not been analyzed by NVD.\n"
echo "Vulnrichment has covered $adp_extra_count CVEs that have been analyzed by NVD.\n"
echo "Vulnrichment has covered $percentage_done% of the $target_count still to be analyzed by NVD.\n"
