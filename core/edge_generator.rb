require_relative 'edge'
require_relative 'util/graph_util'

class EdgeGenerator
  include GraphUtil

  attr_reader :edges_neighbors

  def initialize(edges)
    edges.each do |e|
      unless e.class == Edge
        raise ArgumentError, 'every elements in edges need to be a Edge class'
      end
    end
    @edges = edges
  end

  def find_edges_combination(edges)
    sum_edge = 0
    @edges_neighbors = {}
    edges.each do |edge|
      @edges_neighbors[edge.id.to_s] = find_edge_neighbors(edge)
    end
  end

  def find_edge_neighbors(edge)
    included_edges = find_edge_include(edge.dst)
    included_edges += find_edge_include(edge.src)
    included_edges.delete(edge)
    included_edges.uniq!
  end



end
