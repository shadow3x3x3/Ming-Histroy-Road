require_relative 'edge'
require_relative 'util/graph_util'

class EdgeGenerator
  include GraphUtil

  attr_reader :edges_neighbors, :new_edges

  def initialize(edges)
    edges.each do |e|
      unless e.class == Edge
        raise ArgumentError, 'every elements in edges need to be a Edge class'
      end
    end
    @edges = edges
    @new_edges = []
    @edges_neighbors = {}
  end

  def find_edges_combination(deep_limit: 3)
    @deep_limit = deep_limit

    generator_edges = []

    find_edge_neighbors

    @edges.each do |edge|
      puts edge.id
      get_combination(edge)
    end
  end

  def find_edge_neighbors
    @edges.each do |edge|
      @edges_neighbors[edge.id] = find_neighbors_in(edge)
    end
  end

  def find_neighbors_in(edge)
    neighbors_edges = find_edge_include(edge.src, edge.type)
    neighbors_edges += find_edge_include(edge.dst, edge.type)
    neighbors_edges.delete(edge)
    neighbors_edges.uniq
  end

  def find_edge_include(node, type)
    result_edges = []
    @edges.each do |edge|
      next unless edge.type == type
      result_edges << edge if edge.src == node || edge.dst == node
    end
    result_edges
  end

  def get_combination(cur_edge, deep = 1, pass = [])
    deep += 1
    pass << cur_edge
    # show_pass(pass)
    @edges_neighbors[cur_edge.id].each do |neigh_edges|
      next if pass.include?(neigh_edges)
      temp_edge = combine_to_edge(cur_edge, neigh_edges)
      if new_edge?(temp_edge)
        puts "#{temp_edge.src} - #{temp_edge.dst} - #{temp_edge.dist} - #{temp_edge.type}"
        @new_edges << temp_edge
      end
      get_combination(neigh_edges, deep, pass) if deep < @deep_limit
    end
    pass.delete(cur_edge)
  end

  def show_pass(pass)
    pass.each do |e|
      puts "#{e.src} - #{e.dst}"
    end
  end

  def combine_to_edge(edge1, edge2)
    new_edge = Edge.new
    new_edge.src, new_edge.dst = get_new_edge_src_dst(edge1, edge2)
    new_edge.set_dist(edge1.dist + edge2.dist)
    new_edge.type = edge1.type
    new_edge
  end

  def get_new_edge_src_dst(edge1, edge2)
    new_src_dst = ([edge1.src, edge1.dst] | [edge2.src, edge2.dst]) -
      ([edge1.src, edge1.dst] & [edge2.src, edge2.dst])
    if new_src_dst.size < 2
      raise "combine between #{edge1.src}-#{edge1.dst} and #{edge2.src}-#{edge2.dst}"
    end
    new_src_dst
  end

  def new_edge?(edge)
    @new_edges.each do |n_edge|
      return false if same_edge?(edge, n_edge)
    end
    true
  end

end
