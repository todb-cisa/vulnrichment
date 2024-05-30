#!/bin/zsh

adp_analyzed_file="adp-analyzed.csv"
nvd_awaiting_file="nvd-awaiting.csv"
adp_todo_file="adp-todo.txt"
adp_done_file="adp-done.txt"

adp_cves=$(tail -n +2 "$adp_analyzed_file" | cut -d',' -f1 | sort)
nvd_cves=$(tail -n +2 "$nvd_awaiting_file" | cut -d',' -f1 | sort)

comm -13 <(echo "$adp_cves") <(echo "$nvd_cves") > "$adp_todo_file"
comm -12 <(echo "$adp_cves") <(echo "$nvd_cves") > "$adp_done_file"

adp_todo_count=$(wc -l < "$adp_todo_file" | tr -d ' ')
adp_done_count=$(wc -l < "$adp_done_file" | tr -d ' ')

total_count=$((adp_todo_count + adp_done_count))
percentage_done=$((adp_done_count * 100 / total_count))

echo "Vulnrichment has covered $adp_done_count CVEs, with $adp_todo_count left to do."
echo "Vulnrichment has covered $percentage_done% of the $total_count still to be analyzed by NVD."
