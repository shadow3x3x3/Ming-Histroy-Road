require 'bigdecimal'

require_relative './graph_util'
require_relative 'IO/read_util'
require_relative './edge'
require_relative './node'

# Normal Graph class
class Graph
  include GraphUtil, ReadUtil

  attr_reader :edges, :nodes

  def initialize(params = {})
    raw_nodes = params[:raw_nodes]
    raw_edges = params[:raw_edges]
    @nodes = []
    @edges = []
    initialize_nodes(raw_nodes) unless raw_nodes.nil?
    initialize_edges(raw_edges) unless raw_edges.nil?
  end

  def add_node(node)
    new_node = node.class == Node ? node : Node.new(node)
    @nodes << new_node unless duplicate_node?(new_node)
  end

  def add_edge(edge)
    new_edge = edge.class == Edge ? edge : Edge.new(edge)
    @edges << check_nodes_in_edge(new_edge)
  end

  # return km
  def euclidean_dist(node1, node2)
    ((Math.sqrt(((BigDecimal(node1.long.to_s) - BigDecimal(node2.long.to_s)) ** 2) +
      ((BigDecimal(node1.lat.to_s) - BigDecimal(node1.lat.to_s)) ** 2))) * 111).round(4)
  end

  private

  def find_edges_neighbors(target_edge)
    neighbor_edges = []
    @edges.each do |edge|
      neighbor_edges << edge if edge.connect?(target_edge)
    end
    neighbor_edges
  end

  def check_nodes_in_edge(edge)
    new_node = find_node_by_name(edge.src.name)
    edge.src = new_node unless new_node.nil?
    new_node = find_node_by_name(edge.dst.name)
    edge.dst = new_node unless new_node.nil?
    edge
  end
end
