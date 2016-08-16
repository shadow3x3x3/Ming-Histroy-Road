module GraphUtil
  def find_neighbors(node)
    neighbors = []
    @edges.each do |edge|
      neighbors << check_neighbor(node, edge)
    end
    neighbors.compact!
  end

  def check_neighbor(node, edge)
    case node
    when edge.src
      return edge.dst
    when edge.dst
      return edge.src
    end
  end

  def find_edge(src, dst)
    @edges.each do |edge|
      return edge if edge.src == src && edge.dst == dst
      return edge if edge.src == dst && edge.dst == src
    end
    raise ArgumentError, "not connect between #{src} and #{dst}"
  end

  def same_edge?(edge1, edge2)
    edge1_src_id = edge1.src
    edge1_dst_id = edge1.dst
    edge2_src_id = edge2.src
    edge2_dst_id = edge2.dst
    return true if edge1_src_id == edge2_src_id && edge1_dst_id == edge2_dst_id
    return true if edge1_dst_id == edge2_src_id && edge1_src_id == edge2_dst_id
    false
  end

  def duplicate_edge?(new_edge)
    @edges.each do |edge|
      return true if same_edge?(edge, new_edge)
    end
    false
  end

  def same_edge?(edge1, edge2)
    edge1_src_id = edge1.src
    edge1_dst_id = edge1.dst
    edge2_src_id = edge2.src
    edge2_dst_id = edge2.dst
    return true if edge1_src_id == edge2_src_id && edge1_dst_id == edge2_dst_id
    return true if edge1_dst_id == edge2_src_id && edge1_src_id == edge2_dst_id
    false
  end
end
