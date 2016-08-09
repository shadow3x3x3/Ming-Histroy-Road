require 'csv'
require_relative '../edge'
require_relative '../node'
require_relative '../util/graph_util'


class ReadMing
  attr_accessor :edges, :nodes

  include GraphUtil

  def initialize(edge_path: nil, node_path: nil)
    @edges = []
    @nodes = []
    read_edges(edge_path)
    read_nodes(node_path)
  end

  def read_edges(file_path)
    CSV.foreach(file_path, headers: true, encoding: 'CP950') do |row|
      next if row['distance'].nil?
      between = row['name'].encode('utf-8').split('～')
      next if between[0] == between[1]

      edge = Edge.new
      edge.id  = row['id']
      edge.src = between[0]
      edge.dst = between[1]
      edge.set_dist(row['distance'].to_f)
      edge.type = row['type'].encode('utf-8') unless row['type'].nil?

      @edges << edge unless duplicate_edge?(edge)
    end
  end

  def read_nodes(file_path)
    raw_nodes = File.read(file_path)

    raw_nodes.each_line do |line|
      line = line.encode('UTF-8').split(',')

      node = Node.new
      node.id   = line[1].to_s
      node.name = line[2].to_s
      node.long = line[3].to_f
      node.lat  = line[4].to_f
      @nodes << node
    end

  end

end
