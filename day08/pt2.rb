dirs = "LRRLLRLLRRLRRLLRRLLRLRRRLLRRLRRRLRRLRRRLLRRLLRLLRRLRLRRRLRRLLRRRLRLRRLRRLRLRLRLLRLRRRLLRLLRRLRRRLRLRLRRRLRRLLRRRLRLRRLRRLLRRLRRRLRRLRRLRRLLRLRLRRLLRLLRRRLRRLRRLRRRLRLLRRRLRRRLRRLLRRRLRRRLRLLRLRRLRLLRRLLLRRLRRLRRLRLRRRLRRLLRLRRRLRRLRLLLRRLRRLRRRLLLRLLLLRRLRLLLRLRRRLRRRLRLRRRLLLLRLRRRLRLLLRRLRLRRLRRLRRRLRRRR".chars
# dirs = "LR".chars
num_dirs = dirs.size
nodes = {}
File.readlines('input')
    .each { |line|
      node, left, right = line.strip.split(" ")
      nodes[node] = [left, right]
    }

def done?(all)
  all.all? { |a| a[2] == "Z" }
end

start_nodes = nodes.keys.filter { |k| k[2] == "A" }
all_ends = start_nodes.flat_map { |start_node|
  dir = dirs.cycle
  steps = 0
  dir_index = 0
  states = Set.new
  node = start_node
  end_steps = []
  until states.include?([node, dir_index])
    end_steps << steps if node[2] == "Z"
    states << [node, dir_index]
    steps += 1
    dir_index = (dir_index + 1) % num_dirs
    next_dir = dir.next
    node = nodes[node][next_dir == "L" ? 0 : 1]
  end
  puts "Cycle length for #{start_node}: #{steps}"
  end_steps
}
puts "All ends: #{all_ends}"
puts "Shortest: #{all_ends.reduce(&:lcm)}"