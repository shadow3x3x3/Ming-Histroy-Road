require_relative './graph_util'
require_relative 'IO/read_util'
require_relative './edge'
require_relative './node'

# Normal Graph class
class Graph
  include GraphUtil, ReadUtil

  attr_accessor :edges, :nodes

  def initialize(params = {})
    raw_nodes = params[:raw_nodes]
    raw_edges = params[:raw_edges]
    @dim   = params[:dim]
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

  def check_nodes_in_edge(edge)
    new_node = find_node_by_name(edge.src.name)
    edge.src = new_node unless new_node.nil?
    new_node = find_node_by_name(edge.dst.name)
    edge.dst = new_node unless new_node.nil?
    edge
  end
end
