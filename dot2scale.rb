#!/usr/bin/env ruby

# This software is (c) 2012 Michael A. Cohen
# It is released under the simplified BSD license, which can be found at:
# http://www.opensource.org/licenses/BSD-2-Clause
# 
# This script takes a .dot file to which graphviz has added node coordinates
# (in points) and outputs a .csv with the coordinates in meters

require 'rubygems'
require 'csv'

# DOTScaler is the main class that loops through the input file,
# looking for the kinds of nodes specified on the command line
# and scaling the coordinates
class DOTScaler
  VERSION = '0.1'.freeze
  
  def initialize(infilename, outfilename, node_types)
    @infilename = infilename
    @outfilename = outfilename
    if node_types.nil? || node_types.empty?
      raise "You must specify the node types to extract, comma separated (without spaces), as the third parameter"
    else
      @node_types = node_types.split ','
    end
    @nodes = []
    # prefix to add to node ids to convert from abbreviated form used in .dot
    # files to full form used by feeder_generator.  Should look like "R1-12-47-1_".
    @prefix = File.basename(@infilename)[0..-5].tr('.', '-') + '_'
  end
  
  def scale(n)
    # .dot coordinates are in publishing points and we want scale meters out, so:
    # 72 points per in...
    # 200 ft per in (that's the scale that glm2dot uses)...
    # 3.2808399 ft per m...
    n.to_f / 72.0 * 200.0 / 3.2808399     
  end
  
  # Parse the requested node types in the .dot file into an array of ruby objects
  def parse
    infile = File.open @infilename
    obj_id = in_node = nil
    node_re = Regexp.union(@node_types)
    
    while l = infile.gets do  
      if l =~ /^\s+([a-zA-Z0-9_.]+)\s+\[/
        # we've found a line like "	meter1	 [fillcolor=2,"
        temp_object_name = $1
        unless in_node.nil?
          raise "I found the start of the next object without finding a position for #{in_node}.\nLine: #{l}"
        end        
        #if @node_types.include? $1    # <---  This is original 'if' line here...
        if temp_object_name.match(node_re)  
           #@node_types.find_all {|v| $1.grep(/v/)}
           #or if $1.match(node_re)
          obj_id = temp_object_name
          puts temp_object_name
          in_node = @prefix + temp_object_name
          puts "Searching for position of node #{in_node}"
        end
      elsif !in_node.nil? && l =~ /.*pos="(-*[0-9.]+),(-*[0-9.]+)",/
        puts "Found position of node #{in_node}"
        @nodes << [obj_id, in_node, scale($1), scale($2)]
        obj_id = in_node = nil
      end
    end
    
    raise "I hit the end of the file without finding a position for #{in_node}" unless in_node.nil?
    infile.close
  end
  
  # write out a csv file with the extracted, scaled coordinates for the nodes
  def write
    # note: using windows linebreaks to be on the safe side; not sure if ArcMap requires them
    CSV.open(@outfilename, 'w', :row_sep => "\r\n") do |out_f|
      out_f << ["ObjectID", "node", "x_meters", "y_meters"]
      @nodes.each {|row| out_f << row}
    end
  end
end

# Main execution of the script.  Just grabs the parameters and tells
# GLMConverter to do its thing
infilename = ARGV[0]
outfilename = ARGV[1]
node_types = ARGV[2]

converter = DOTScaler.new infilename, outfilename, node_types
converter.parse
converter.write