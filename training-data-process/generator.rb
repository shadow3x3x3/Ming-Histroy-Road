require_relative 'structure/graph'

class Generator
  attr_reader :core_nodes, :core_edges, :training_data

  def initialize(nodes_data, edges_data)
    @graph = Graph.new(raw_nodes: nodes_data, raw_edges: edges_data)

    @core_nodes = []
    @core_edges = []

    @training_data = []
  end

  def gernerate
    find_core_nodes
    combinations = find_combination_by_core_nodes

    find_core_edges

    combinations.each do |c|
      # TODO output
      # puts "#{c[0].name} - #{c[1].name} - #{edge} - #{dist} - #{hop_num}"
    end
  end

  def find_core_nodes
    @graph.degrees_table.each do |node, value|
      next if value.size <= 0
      @core_nodes << node if value.size < 2 || value.size >= 3
    end
  end

  def find_combination_by_core_nodes
    combinations = @core_nodes.repeated_combination(2).to_a
    combinations.delete_if {|c| c[0] == c[1]  }
  end

  def find_core_edges
    id = 0
    @core_nodes.each do |c_n|
      core_nodes = @core_nodes.clone
      core_nodes.delete_if {|cn| cn.name == c_n.name }
      paths = @graph.find_all_paths(src: c_n, c_nodes: core_nodes)
      unless paths.empty?
        id += 1
        paths.each do |path|
          @core_edges << CoreEdge.new(id, path.first, path.last, path, path_to_edge(path))
        end
      end
    end
  end

  def path_to_edge(path)
    edges = []
    path.each
    path.each_with_index do |v, i|
      next if i == path.size - 1
      next_v = path[i + 1]
      edges << @graph.find_edge_between(v, next_v)
    end
    edges
  end
end

class CoreEdge
  attr_reader :id, :nodes, :edges, :dist

  def initialize(id, src, dst, nodes, edges)
    @id    = id
    @nodes = nodes
    @edges = edges
    @dist  = calc_dist
  end

  def include_node?(target_node)
    @nodes.each {|node| return true if node.name == node.name }
    false
  end

  def calc_dist
    dist = 0
    @edges.each {|edge| dist += edge.dist }
    dist
  end
end
