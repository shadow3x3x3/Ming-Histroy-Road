require_relative 'structure/graph'

class Generator
  def initialize(nodes_data, edges_data)
    @graph = Graph.new(raw_nodes: nodes_data, raw_edges: edges_data)

    @core_nodes = []

    @training_data = []
  end

  def gernerate
    find_core_nodes
    combinations = find_combination_by_core_nodes
  end

  def find_core_nodes
    @graph.degrees_table.each do |node, value|
      next unless value.size <= 0
      @core_nodes << node if value.size < 2 || value.size >= 3
    end
  end

  def find_combination_by_core_nodes
    combinations = @core_nodes.repeated_combination(2).to_a
    combinations.delete_if {|c| c[0] == c[1]  }
  end

end
