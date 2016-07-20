require 'csv'
require_relative '../edge'

class ReadMing
  attr_reader :edges

  def initialize(file_path)
    @edges = []
    read(file_path)
  end

  def read(file_path)
    edge_num = 0

    raw_edges = File.read(ROAD_PATH)
    CSV.foreach(ROAD_PATH, headers: true, encoding: 'CP950') do |row|
      next if row['distance'].nil?
      edge_num += 1
      between = row['name'].encode('utf-8').split('～')

      edge = Edge.new
      edge.id  = row['id']
      edge.src = between[0]
      edge.dst = between[1]
      edge.set_dist(row['distance'].to_f)
      edge.type = row['type'].encode('utf-8') unless row['type'].nil?

      @edges.push(edge)
    end
  end

end
