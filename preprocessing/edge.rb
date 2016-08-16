# Record Edge
class Edge
  attr_accessor :id, :src, :dst, :attrs, :type

  def initialize
    @id    = "UNKNOW"
    @attrs = [0]
    @type  = "UNKNOW"
  end

  def set_dist(distance)
    @attrs[0] = distance
  end

  def dist
    @attrs.first
  end

  def min_value
    @attrs.last
  end
end
