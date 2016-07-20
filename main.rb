require_relative 'core/IO/read_ming'

ROAD_PATH = './ming_data/mingroad_fix.csv'.freeze

ming = ReadMing.new(ROAD_PATH)


ming.edges.each do |e|
  puts "==#{e.id}=="
  puts "src:  #{e.src}"
  puts "dst:  #{e.dst}"
  puts "type: #{e.type}"
  puts "dist: #{e.attrs[0]}"
end
