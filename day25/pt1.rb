def absorb_node(edges, to_absorb, new_parent, set_sizes)
  child_edges = edges.delete(to_absorb)
  parent_edges = edges[new_parent]
  parent_edges.concat(child_edges)
  edges[new_parent] -= [to_absorb, new_parent] # Remove all self-references
  edges.each { |node, neighbors|
    neighbors.map! { |neighbor| neighbor == to_absorb ? new_parent : neighbor }
  }
  set_sizes[new_parent] += set_sizes[to_absorb]
end

def kargers(edges, set_sizes)
  while edges.size > 2
    # Pick a random edge
    source = edges.keys.sample
    target = edges[source].to_a.sample
    absorb_node(edges, target, source, set_sizes)
  end

  set_size_product = 1
  edges.each { |node, neighbors|
    set_size = set_sizes[node]
    puts "Set size: #{set_size}"
    set_size_product *= set_size
  }

  cuts = edges.first[1].size
  puts "Set size product: #{set_size_product}" if cuts == 3
  cuts
end

cuts = Float::INFINITY
while cuts != 3
  edges = Hash.new { |h, k| h[k] = [] }
  set_sizes = Hash.new { |h, k| h[k] = 1 }
  # File.readlines("test_input")
  File.readlines("input")
    .each { |line|
      source, *targets = line.strip!.split(" ")
      targets.each { |target|
        edges[source] << target
        edges[target] << source
      }
    }

  cuts = kargers(edges, set_sizes)
end