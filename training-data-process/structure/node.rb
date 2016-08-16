# Record Ming Node
class Node
  attr_reader :id, :name, :long, :lat

  def initialize(attrs)
    init_array(attrs)
    @neighbors = []
  end

  def add_neighbor(node)
    raise "node need to be Node object" unless node.class == Node
    @neighbors << node unless @neighbors.include?(node)
  end

  private

  def init_array(attrs)
    @id   = attrs.shift
    @name = attrs.shift
    @long = attrs.shift.to_f
    @lat  = attrs.shift.to_f
  end
end
