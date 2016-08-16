module OutputToTxt
  def write_edges
    File.open('../output/ming2_edges.txt', "w") do |f|
      @edges.each do |edge|
        f.write("#{edge.id}   #{edge.src}   #{edge.dst}   #{edge.dist}\n")
      end
    end
  end

  def write_nodes
    File.open('../output/ming_nodes.txt', "w") do |f|
      @nodes.each do |node|
        f.write("#{node.id}   #{node.name}   #{node.long}   #{node.lat}\n")
      end
    end
  end

  def random
    ('0'..'9').to_a.sample(8).join.to_f / 1_000_000
  end

end
