#! bin/bash

for inch in ./*.faa; do
outfile=$(basename $inch .faa)
RENAME=$(basename $inch .faa)

sed  's/^>/>'$RENAME' /g' $inch > $outfile"_renamed".faa
done
