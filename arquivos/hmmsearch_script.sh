#! bin/bash

for one in ./ncbi_dataset/data/*_renamed.faa; do

seq_file=$(basename $one)

for hmm_file in ./hmm_build_one/*; do
seq_hmm=$(basename $hmm_file)

output_file="${seq_hmm}_${seq_file}_out_hmmer.tsv"

hmmsearch --cpu 15 --domtblout "$output_file" "$hmm_file" "$one"


  #Coverage calculation
        coverage_file="${output_file}_coverage"
        awk 'NR==4 {result = ((($19 - $18) + 1) / $3) * 100; printf "%s %s\n", result, ARGV[1]}' "$output_file" > "$coverage_file"
        
        echo "Executado: $hmm_name contra $seq_name. Saída em $output_file"
	

done
done
