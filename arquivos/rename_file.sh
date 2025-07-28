#! bin/bash

for file in ./*/protein.faa; do

RENAME=$(dirname $file)
OUT=$(basename $RENAME .faa)

mv $file $RENAME".faa"
done
