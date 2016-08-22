# Record Ming Node
class Node
  attr_reader :id, :name, :long, :lat, :neighbors

  def initialize(attrs)
    attrs.class == Array ? init_array(attrs) : init_by_edge(attrs)
    @neighbors = []
  end

  def add_neighbors(node)
    raise "expect(Node) got (#{node.class})" unless node.class == Node
    @neighbors << node unless @neighbors.include?(node)
  end

  def in_edge?(edge)
    name == edge.src.name || name == edge.src.name
  end

  private

  def init_array(attrs)
    @id   = attrs.shift
    @name = attrs.shift
    @long = attrs.shift.to_f
    @lat  = attrs.shift.to_f
  end

  def init_by_edge(attrs)
    @id   = 'NOT_EXIST'
    @name = attrs
    @long = 'NOT_EXIST'
    @lat  = 'NOT_EXIST'
  end
end
