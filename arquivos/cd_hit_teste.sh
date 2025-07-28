#! bin/bash



for file in ./*fasta; do
OUTPUT=$(basename $file .fasta) 

cd-hit -i $file -o $OUTPUT"_out"  -c 1.00 -n 5
done

