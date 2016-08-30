# glm2dot

glm2dot is a ruby script designed to work with [graphviz](http://www.graphviz.org/) to create graphical representations and positional coordinate information for distribution feeder networks described by the [GridLAB-D](http://www.gridlabd.org/) .glm file format, and was designed specifically to work with the [taxonomy feeders](http://gridlab-d.sourceforge.net/wiki/index.php/Feeder_Taxonomy) which are part of the GridLAB-D project, though it may work with other feeder models as well.

The best way to get a feel for what glm2dot does is to look at some [example output](http://emac.berkeley.edu/gridlabd/taxonomy_graphs/) for the taxonomy feeders.

## License

GLMWrangler is © 2012 by Michael A. Cohen and Christopher Saunders. It is released under the [simplified BSD license](https://opensource.org/licenses/BSD-2-Clause).

## Dependencies

glm2dot was most recently tested by the authors with

- Ruby 2.1.5
- Graphviz 2.38

and will likely work with those versions or newer.

## File Inventory

**glm2dot.rb:** Takes a GridLAB-D .glm file as an input, processes it, and generates an output file in the .dot format, which may then be further processed using Graphviz.

**dot2scale.rb:** Takes a .dot file which has been post-processed using Neato (which is part of the Graphviz tool set), and extracts the (x,y) coordinates assigned by Neato to a comma-separated variable (.csv) file.

**glm2dot\_batch.sh:** Runs glm2dot.rb  iteratively on a set of .glm files, outputting a set of corresponding .dot files. It will then use Neato to generate a set of graphical output files for the .dot files. The graphical output format can be chosen by editing the script.

**dot\_with\_coords_batch.sh:** Takes a set of .dot files, and uses Neato to generate an updated set of .dot files which contain positional coordinates, chosen by Neato.

**dot2scale\_batch.sh:** Takes a set of .dot files which are already updated with coordinates from Neato, and extracts .csv files containing the positional coordinates for the user-selected types of grid elements.
      
## Sample Usage

### Using glm2dot.rb

To transform a .glm file named `example_in.glm` into an output .dot file named `example_out.dot`, invoke glm2dot.rb from the command line:

```
ruby glm2dot.rb path/to/example_in.glm path/to/example_out.dot
```

### Running Neato on the .dot file

Neato is the tool which takes the .dot file output from glm2dot.rb (which has no geographical coordinate information), and calculates an estimated geographical configuration for the network. It then outputs this configuration as an image or an an annotated .dot file (which is basically your original file with coordinates added) depending on its arguments.
.
For generating a graphical output file, the command line usage is:

```
neato example_out.dot -Tpdf -oexample_out.pdf
```

The `-T` option indicates the output format (which can be pdf, svg, png, etc.), and the -o option determines the output file name. NOTE the lack of space between the options and their values!

To generate a new .dot file that contains the positional coordinates of the network elements rather than a visual representation, simply omit the output format:

```
neato example_out.dot -oexample_out_with_coords.dot
```

Please refer to the [Graphviz documentation](http://www.graphviz.org/doc/info/command.html) for more details and options. 

### Using dot2scale.rb

dot2scale.rb extracts the (x,y) coordinates assigned to the elements of the .dot file by Neato. In order to use this tool, you must first create a .dot file using glm2dot.rb, and then run Neato to obtain a .dot file including coordinates, as described above. The (x,y) coordinates of the chosen elements are extracted and output to a .csv file. Usage is as follows:

```
ruby dot2scale.rb example_out_with_coords.dot example_out_csv.csv meter,tm
```
    
In the above command line call, the input dot file is a .dot file with coordinates, the output file will be a comma separated variable (.csv) file, and the last portion of the command line arguments indicates which elements within the .dot file you wish to collect locations for in the .csv file. For example, in the given case, the positions (as determined by Neato) of all meters and triplex meters will be a part of the output set, due to the ‘meter,tm’ argument. Note that this is a set of comma-separated arguments with **no** spaces in between.
