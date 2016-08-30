#!/bin/bash
for f in taxonomy/glm/*.glm
do
 b=$(basename $f .glm)
 ruby glm2dot_repo/glm2dot.rb $f taxonomy/dot/$b.dot "Michael A. Cohen (macohen@berkeley.edu)"
 neato taxonomy/dot/$b.dot -Tpdf -otaxonomy/pdf/$b.pdf
done