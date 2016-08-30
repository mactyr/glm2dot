#!/bin/bash
for f in taxonomy/dot/*.dot
do
 b=$(basename $f .dot)
 neato taxonomy/dot/$b.dot -otaxonomy/dot_with_coords/$b.dot
done