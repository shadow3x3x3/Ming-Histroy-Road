# require 'pry-byebug'

require_relative 'structure/IO/output_util'
require_relative 'structure/graph'

class Generator
  attr_reader :core_nodes, :core_edges, :training_data

  def initialize(nodes_data, edges_data)
    @graph = Graph.new(raw_nodes: nodes_data, raw_edges: edges_data)

    @core_nodes = []
    @core_edges = []

    @training_data = []
    @start_codes   = []
    @hop_numbers   = []
    @distances     = []
  end

  def gernerate
    find_core_nodes
    find_core_edges
    finding_training_path(find_combination_by_core_nodes)
    # output
  end

  def finding_training_path(combinations)
    combinations.each do |c|
      full_path = ""
      find_core_path(c[0], c[1]).each do |path|
        path.each { |node| full_path += "#{node.id}_" }
        full_id = ""
        core_path_to_core_edge(path).each { |e| full_id += e.id.to_s }
        full_dist = core_path_dist(path)
        @start_codes << [nums_string_encoding(full_id), to_day(full_dist).to_s].flatten
        @training_data <<
          [c[0].id, c[1].id, full_path[0..-2], nums_string_encoding(full_id), full_dist.to_s, to_day(full_dist).to_s].flatten
      end
    end


  end

  def output
    OutputUtil.output_start_codes_csv("output/ming_start_coding.csv", @start_codes)

    @core_edges.each { |c_e| @hop_numbers << c_e.hop_numbers.to_s }
    OutputUtil.output_setting_csv("output/ming_hop_numbers.csv", @hop_numbers)

    @core_edges.each { |c_e| @distances << c_e.dist.to_s }
    OutputUtil.output_setting_csv("output/ming_dist.csv", @distances)
  end

  def nums_string_encoding(nums)
    coding = "0000"
    nums.each_char { |chr| coding[chr.to_i - 1] = "1" }
    coding.split("")
  end

  def core_nodes_hash
    hash = {}
    @core_nodes.each { |node| hash[node.id] = node.name }
    hash
  end

  def find_core_nodes
    @graph.degrees_table.each do |node, value|
      next if value.size == 0 || value.size == 2
      @core_nodes << node
    end
  end

  def find_combination_by_core_nodes
    combinations = @core_nodes.repeated_combination(2).to_a
    combinations.delete_if { |c| c[0] == c[1] }

    temp_array = [] # for delete duplicates edges
    result = []
    combinations.each do |c|
      next if temp_array.include?([c[1].name, c[0].name])
      next if temp_array.include?([c[0].name, c[1].name])
      temp_array << [c[0].name, c[1].name]
      result << c
    end
    puts '==combinations=='
    result.each {|r| puts "#{r[0].name} - #{r[1].name}" }
    result
  end

  def find_core_edges
    id = 0
    @core_nodes.each do |c_n|
      core_nodes = @core_nodes.clone
      core_nodes.delete_if { |cn| cn.name == c_n.name }
      paths = @graph.find_all_paths(src: c_n, c_nodes: core_nodes)
      unless paths.empty?
        paths.each do |path|
          unless duplicate_core_edge?(path.first, path.last)
            id += 1
            @core_edges << CoreEdge.new(id, path.first, path.last, path, path_to_edge(path))
          end
        end
      end
    end
  end

  def find_core_path(src, dst)
    paths = []
    path_recursive(src, dst, paths, [])
  end

  def duplicate_core_edge?(node1, node2)
    @core_edges.each do |c_e|
      return true if c_e.src.name == node1.name && c_e.dst.name == node2.name
      return true if c_e.src.name == node2.name && c_e.dst.name == node1.name
    end
    false
  end

  def path_recursive(node, dst, paths, path)
    path << node
    if node == dst
      path = get_dst(node, paths, path)
      return
    end
    find_core_neighbors(node).each do |n|
      path_recursive(n, dst, paths, path) unless path_include?(path, n)
    end
    path.delete(node)
    paths
  end

  def get_dst(node, paths, path)
    paths << path.clone
    path.delete(node)
  end

  def path_include?(path, n)
     path.each { |node| return true if node.name == n.name }
     false
  end

  def find_core_neighbors(node)
    neighbors = []
    @core_edges.each do |e|
      n = check_neighbor(e, node)
      neighbors << n unless n.nil?
    end
    neighbors
  end

  def path_to_edge(path)
    edges = []
    path.each_with_index do |v, i|
      next if i == path.size - 1
      next_v = path[i + 1]
      found_edge = @graph.find_edge_between(v, next_v)
      edges << found_edge unless found_edge.nil?
    end
    edges
  end

  def core_path_to_core_edge(path)
    edges = []
    path.each_with_index do |v, i|
      next if i == path.size - 1
      next_v = path[i + 1]
      found_edge = find_core_edge_between(v, next_v)
      edges << found_edge unless found_edge.nil?
    end
    edges
  end

  def find_core_edge_between(node1, node2)
    @core_edges.each do |edge|
      return edge if edge.between?(node1, node2)
    end
    nil
  end

  def check_neighbor(edge, node)
    case node.name
    when edge.src.name
      edge.dst
    when edge.dst.name
      edge.src
    else
      return nil
    end
  end

  def core_path_dist(path)
    full_dist = core_path_to_core_edge(path).inject(0) do |dist, edge|
      dist += edge.dist
    end
    full_dist
  end

  def to_day(dist)
    (dist / 50 + rand(-1..1) + rand).round(2)
  end
end

class CoreEdge
  attr_reader :id, :src, :dst, :nodes, :edges, :dist

  def initialize(id, src, dst, nodes, edges)
    @id    = id
    @src   = src
    @dst   = dst
    @nodes = nodes
    @edges = edges
    @dist  = calc_dist
  end

  def include_node?(target_node)
    @nodes.each { |node| return true if node.name == node.name }
    false
  end

  def calc_dist
    dist = 0
    @edges.each { |edge| dist += edge.dist }
    dist
  end

  def between?(node1, node2)
    return true if @src.name == node1.name && @dst.name == node2.name
    return true if @dst.name == node1.name && @src.name == node2.name
    false
  end

  def hop_numbers
    @edges.size
  end
end
