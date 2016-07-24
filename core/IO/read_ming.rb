require 'csv'
require_relative '../edge'
require_relative '../util/graph_util'


class ReadMing
  attr_accessor :edges

  include GraphUtil

  def initialize(file_path)
    @edges = []
    read(file_path)
  end

  def read(file_path)
    raw_edges = File.read(ROAD_PATH)

    CSV.foreach(ROAD_PATH, headers: true, encoding: 'CP950') do |row|
      next if row['distance'].nil?
      between = row['name'].encode('utf-8').split('～')
      next if between[0] == between[1]

      edge = Edge.new
      edge.id  = row['id']
      edge.src = between[0]
      edge.dst = between[1]
      edge.set_dist(row['distance'].to_f)
      edge.type = row['type'].encode('utf-8') unless row['type'].nil?

      @edges.push(edge) unless duplicate_edge?(edge)
    end
  end

end
