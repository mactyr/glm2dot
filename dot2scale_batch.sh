#!/bin/bash
for f in taxonomy/dot_with_coords/*.dot
do
 b=$(basename $f .dot | sed 's/\.//g') # "." in filename confuses ArcMap
 ruby glm2dot_repo/dot2scale.rb $f taxonomy/csv/$b.csv meter,tm
done