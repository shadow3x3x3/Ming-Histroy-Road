# general Util for graph
module GraphUtil
  def find_all_paths(params)
    src        = params[:src]
    core_nodes = params[:c_nodes]
    find_paths(src, core_nodes)
  end

  private

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

  def find_node(name)
    # puts name
    @nodes.each { |n| return n if n.name == name }
  end

  def find_node_by_name(target)
    @nodes.each { |n| return n if n.name == target }
    nil
  end

  def find_paths(src, core_nodes)
    paths = []
    path_recursive(src, core_nodes, paths, [])
  end

  def path_recursive(node, core_nodes, paths, path)
    path << node

    # path.each {|n| puts n.name }
    if core_nodes.include?(node)
      path = get_dst(node, paths, path)
      return
    end
    node.neighbors.each do |n|
      path_recursive(n, core_nodes, paths, path) unless path.include?(n)
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

  def same_node?(node1, node2)
    return true if node1.name == node2.name
    return true if node1.id == node2.id
    false
  end

  def get_dst(node, paths, path)
    paths << path.clone
    path.delete(node)
  end

  def check_neighbor(edge, node)
    case node.name
    when edge.src.name
      edge.dst
    when edge.dst.name
      edge.src
    else
      return nil
    end
  end
end
