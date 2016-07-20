require_relative 'edge'

class EdgeGenerator
  def initialize(edges)
    edges.each do |e|
      unless e.class == Edge
        raise ArgumentError, 'every elements in edges need to be a Edge class'
      end
    end
  end
end
