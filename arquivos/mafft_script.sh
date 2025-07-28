#! bin/bash



mkdir mafft_results

for maria in ./*_out; do

OUTPUT=$(basename $maria _out)
mafft --auto --thread -5 $maria > $OUTPUT.fasta 

mv $OUTPUT.fasta ./mafft_results
done

