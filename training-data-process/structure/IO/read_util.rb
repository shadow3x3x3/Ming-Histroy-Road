# -*- coding: UTF-8 -*-

# Reading raw file module
module ReadUtil
  def initialize_nodes(raw_nodes)
    print "nodes data processing.."
    raw_nodes.each_line do |node|
      node.force_encoding(Encoding::UTF_8)
      node = node.split
      add_node(node)
    end
    puts "..done"
  end

  def initialize_edges(raw_edges)
    print "edges data processing.."
    raw_edges.each_line do |edge|
      edge.force_encoding(Encoding::UTF_8)
      edge = edge.split
      add_edge(edge)
    end
    puts "..done"
  end
end
