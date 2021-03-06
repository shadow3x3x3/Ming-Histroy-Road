require_relative './node'

# Record Edge
class Edge
  attr_reader :id, :dist
  attr_accessor :src, :dst

  def initialize(attrs)
    @id    = attrs.shift
    @src   = Node.new(attrs.shift)
    @dst   = Node.new(attrs.shift)
    @dist  = attrs.shift.to_f
    raise ArgumentError, "value of @dist (#{@dist}) is not a Fixnum" unless @dist.class == Float
  end

  def connect?(edge)
    return true if @src.name == edge.src.name || @src.name == edge.dst.name
    return true if @dst.name == edge.src.name || @dst.name == edge.dst.name
    false
  end

  def include?(node)
    return true if @src.name == node.name || @dst.name == node.name
    false
  end

  def between?(node1, node2)
    return true if @src.name == node1.name && @dst.name == node2.name
    return true if @dst.name == node1.name && @src.name == node2.name
    false
  end
end
