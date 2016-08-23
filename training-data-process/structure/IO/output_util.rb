require 'csv'

module OutputUtil
  def self.output_2_csv(nodes, dataset)
    CSV.open("output/ming_core_node.csv", "wb") do |csv|
      nodes.each { |k, v| csv << [k, v] }
    end

    CSV.open("output/ming_dataset.csv", "wb",
      write_headers: true,
      headers: ["source", "destination", "nodes", "edges", "distance", "days"]) do |csv|
      dataset.each { |data| csv << data }
    end
  end
end
