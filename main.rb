require_relative 'core/IO/read_ming'
require_relative 'core/edge_generator'

ROAD_PATH = './ming_data/mingroad_fix.csv'.freeze

ming = ReadMing.new(ROAD_PATH)
eg = EdgeGenerator.new(ming.edges)
eg.find_edges_combination(deep_limit: 6)

# ming.edges.each do |edge|
#   puts "#{edge.id}: #{edge.src} - #{edge.dst}"
# end

# eg.new_edges.each do |edge|
#   puts "===="
#   puts "#{edge.src} - #{edge.dst}"
#   puts edge.type.to_s
#   puts edge.dist.to_s
# end

puts eg.new_edges.size

# puts ming.edges.first.dst == ming.edges[1].src

# puts "--#{ming.edges.first.id}: #{ming.edges.first.src} - #{ming.edges.first.dst} - #{ming.edges.first.dist}里--"
# eg.edges_neighbors.each do |key, edge|
#   puts "#{key}: #{edge.size}條"
# end


# num = 0
# ming.edges.each do |edge|
#   puts "
# ==#{edge.src} - #{edge.dst}=="
#   if !eg.edges_neighbors[edge.id].nil?
#     eg.edges_neighbors[edge.id].each do |n_edge|
#       puts "#{n_edge.src} - #{n_edge.dst}"
#       num += 1
#     end
#   else
#     puts "No Neighbors Edges"
#   end
# end
#
# puts num / ming.edges.size
