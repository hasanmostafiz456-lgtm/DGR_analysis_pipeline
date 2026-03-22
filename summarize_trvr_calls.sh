#!/usr/bin/env bash
set -euo pipefail

genomes=(
  GUT_GENOME027284
  GUT_GENOME027320
  GUT_GENOME065719
  GUT_GENOME066135
  GUT_GENOME141191
  GUT_GENOME065705
)

raw_out="15_final_TRVR_calls_fixed.tsv"
dedup_out="16_final_TRVR_calls_deduplicated.tsv"

printf "file\tgenome\tcontig\tTR_s\tTR_e\tVR_s\tVR_e\tlen\tmism\tTRside\taTR\tnonA_count\tnonAfrac\tA_pct\tpass_len\tpass_aTR\tpass_nonAfrac\tpass_all\twindow\n" > "$raw_out"

for d in "${genomes[@]}"; do
  f="$d/03_trvr/$d.TRVR.all.tsv"
  [ -s "$f" ] || { echo "Missing: $f" >&2; continue; }

  awk -v file="$f" 'BEGIN{FS=OFS="\t"}
    NF>=12 {
      len=$7+0
      mism=$8+0
      trside=$9
      aTR=$10+0
      nonA=mism-aTR
      nonAfrac=$11+0
      Apct=(mism>0 ? (100*aTR/mism) : 0)

      pass_len=(len>=60 ? "YES":"NO")
      pass_aTR=(aTR>=7 ? "YES":"NO")
      pass_nonA=(nonAfrac<=0.30 ? "YES":"NO")
      pass_all=(pass_len=="YES" && pass_aTR=="YES" && pass_nonA=="YES" ? "YES":"NO")

      print file,$1,$2,$3,$4,$5,$6,len,mism,trside,aTR,nonA,sprintf("%.3f",nonAfrac),sprintf("%.2f",Apct),pass_len,pass_aTR,pass_nonA,pass_all,$12
    }' "$f" >> "$raw_out"
done

awk 'BEGIN{FS=OFS="\t"}
  NR==1 {
    header=$0
    next
  }
  {
    # deduplicate by biological locus, not by Q/S reciprocal representation
    key=$2 FS $3 FS $4 FS $5 FS $6 FS $7 FS $8 FS $9 FS $11 FS $13 FS $19

    if (!(key in idx)) {
      idx[key]=++n
      line[n]=$0
      dup[n]=1
    } else {
      dup[idx[key]]++
    }
  }
  END {
    print header, "duplicate_count"
    for (i=1; i<=n; i++) {
      print line[i], dup[i]
    }
  }' "$raw_out" > "$dedup_out"

echo "Saved:"
echo "  /home/hasan/$raw_out"
echo "  /home/hasan/$dedup_out"
