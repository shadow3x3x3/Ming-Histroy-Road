# general Util for graph
module GraphUtil
  def find_all_paths(params)
    src = find_node(params[:src])
    dst = find_node(params[:dst])
    find_paths(src, dst)
  end

  def find_edges_by_node(node)
    found_edges = []
    @edges.each do |edge|
      found_edges << edge if node_in_edge?(node, edge)
    end
    found_edges
  end

  private

  def find_neighbor
    @edges.each do |e|
      neighbor = check_neighbor(e)
      next if neighbor.nil?
      @neighbors << neighbor
    end
  end

  def duplicate_node?(new_node)
    @nodes.each do |node|
      return true if node.id == new_node.id || node.name == new_node.name
    end
    false
  end

  def duplicate_edge?(new_edge)
    @edges.each do |edge|
      return true if same_edge?(edge, new_edge)
    end
    false
  end

  def find_node(target)
    @nodes.each { |n| return n if n.id == target }
  end

  def find_node_by_name(target)
    @nodes.each { |n| return n if n.name == target }
    nil
  end

  def find_paths(src, dst)
    paths = []
    path_recursive(src.id, dst.id, paths, [])
  end

  def path_recursive(node, dst, paths, path)
    path << node
    if node == dst
      path = get_dst(node, paths, path)
      return
    end
    find_node(node).neighbors.each do |n|
      path_recursive(n, dst, paths, path) unless path.include?(n)
    end
    path.delete(node)
    paths
  end

  def same_edge?(edge1, edge2)
    edge1_src_id = edge1.src.id
    edge1_dst_id = edge1.dst.id
    edge2_src_id = edge2.src.id
    edge2_dst_id = edge2.dst.id
    return true if edge1_src_id == edge2_src_id && edge1_dst_id == edge2_dst_id
    return true if edge1_dst_id == edge2_src_id && edge1_src_id == edge2_dst_id
    false
  end

  def get_dst(node, paths, path)
    paths << path.clone
    path.delete(node)
  end

  def check_neighbor(edge)
    case @id
    when edge.src
      edge.dst
    when edge.dst
      edge.src
    else
      return
    end
  end
end
