#! bin/bash

for habbibs in ./ncbi_dataset/data/*_renamed.faa; do

seq_file=$(basename $habbibs)


output_file="${seq_file}_out_blast.tsv"

blastp -db ./banco_blast/banco_blast -query $habbibs -out $output_file  -outfmt "6  qseqid sseqid qlen qstart qend evalue bitscore length pident ppos"



  #Coverage calculation
        coverage_file="${output_file}_coverage"
        awk 'NR==1 {result = ((($19 - $18) + 1) / $3) * 100; printf "%s %s\n", result, ARGV[1]}' "$output_file" > "$coverage_file"
done

