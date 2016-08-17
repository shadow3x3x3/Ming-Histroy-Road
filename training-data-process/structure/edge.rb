require_relative './node'

# Record Edge
class Edge
  attr_reader :id, :attrs
  attr_accessor :src, :dst

  def initialize(attrs)
    @id    = attrs.shift
    @src   = Node.new(attrs.shift)
    @dst   = Node.new(attrs.shift)
    @dist  = attrs.shift.to_f
    raise ArgumentError, "value of @dist (#{@dist}) is not a Fixnum" unless @dist.class == Float
  end
end
