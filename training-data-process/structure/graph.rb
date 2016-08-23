require 'bigdecimal'

require_relative './graph_util'
require_relative 'IO/read_util'
require_relative './edge'
require_relative './node'

# Normal Graph class
class Graph
  include GraphUtil, ReadUtil

  attr_reader :edges, :nodes, :degrees_table

  def initialize(params = {})
    raw_nodes = params[:raw_nodes]
    raw_edges = params[:raw_edges]
    @nodes = []
    @edges = []
    initialize_nodes(raw_nodes) unless raw_nodes.nil?
    initialize_edges(raw_edges) unless raw_edges.nil?
    calc_neighbors
    @degrees_table = generate_degrees_table
  end

  def add_node(node)
    new_node = node.class == Node ? node : Node.new(node)
    @nodes << new_node unless duplicate_node?(new_node)
  end

  def add_edge(edge)
    new_edge = edge.class == Edge ? edge : Edge.new(edge)
    @edges << check_nodes_in_edge(new_edge)
    # add_nodes_by(@edges.last)
  end

  # return km
  def euclidean_dist(node1, node2)
    ((Math.sqrt(((BigDecimal(node1.long.to_s) - BigDecimal(node2.long.to_s)) ** 2) +
      ((BigDecimal(node1.lat.to_s) - BigDecimal(node1.lat.to_s)) ** 2))) * 111).round(4)
  end

  def is_neighbor?(node1, node2)
    return false if find_edge_between(node1, node2).nil?
    true
  end

  def find_edge_between(node1, node2)
    @edges.each do |edge|
      return edge if edge.between?(node1, node2)
    end
    nil
  end

  private

  def calc_neighbors
    @nodes.each do |node|
      find_neighbors_by(node).each {|nn| node.add_neighbors(nn) }
    end
  end

  def find_neighbors_by(node)
    neighbors = []
    @edges.each do |e|
      n = check_neighbor(e, node)
      neighbors << n unless n.nil?
    end
    neighbors
  end

  def generate_degrees_table
    degrees_table = {}

    @nodes.each do |node|
      degrees_table[node] = []
      find_edges_by(node).each do |n_edge|
        degrees_table[node] << n_edge
      end
    end
    degrees_table
  end

  def find_edges_by(node)
    found_edges = []
    @edges.each do |edge|
      found_edges << edge if edge.include?(node)
    end
    found_edges
  end

  def find_edges_neighbors(target_edge)
    neighbor_edges = []
    @edges.each do |edge|
      neighbor_edges << edge if edge.connect?(target_edge)
    end
    neighbor_edges
  end

  def check_nodes_in_edge(edge)
    new_node = find_node_by_name(edge.src.name)
    if new_node.nil?
      # @nodes << edge.src
    else
      edge.src = new_node
    end

    new_node = find_node_by_name(edge.dst.name)

    if new_node.nil?
      # @nodes << edge.dst
    else
      edge.dst = new_node
    end
    edge
  end

  def add_nodes_by(edge)
    @nodes << edge.src unless duplicate_node?(edge.src)
    @nodes << edge.dst unless duplicate_node?(edge.dst)
  end
end
