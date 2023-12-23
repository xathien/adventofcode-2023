require 'fc'

# grid = File.readlines("test_input")
grid = File.readlines("input")
  .map { |line|
    line.strip!.chars
  }

start_node = [[1, 1], [1, 0], [1, 0], 1] # Start one step in so I never have to check edge boundaries
end_coords = [grid.first.size - 2, grid.size - 1] # Bottom row, second to last column
directions = [[0, -1], [0, 1], [-1, 0], [1, 0]]
vertices = Hash.new { |h, k| h[k] = {} }

# Traverse to find the vertices
queue = [start_node]
until queue.empty?
  current, prev_vertex, prev_coords, steps = queue.pop
  if current == end_coords || vertices.key?(current) # We made it to the end of this path
    vertices[current][prev_vertex] = steps
    vertices[prev_vertex][current] = steps
    next
  end

  # Find forward neighbors
  neighbors = directions.filter_map { |dx, dy|
    next_x, next_y = current[0] + dx, current[1] + dy
    neighbor = [next_x, next_y]
    next if grid[next_y][next_x] == "#" || neighbor == prev_coords
    neighbor
  }

  if neighbors.size > 1 # We've reached a vertex
    vertices[current][prev_vertex] = steps
    vertices[prev_vertex][current] = steps
    prev_vertex = current
    steps = 0
  end

  neighbors.each { |neighbor|
    queue << [neighbor, prev_vertex, current, steps + 1]
  }
end

start = [[1, 0], 0, Set.new]
goal, final_steps = vertices[end_coords].first # Nab the node before the exit since there's only one path
queue = [start]
max_steps_taken = 0
longest_path_vertices = nil

while state = queue.pop
  current, path_steps, visited = state
  if current == goal # Found the exit
    if path_steps > max_steps_taken
      max_steps_taken = path_steps
      longest_path_vertices = visited
    end
    next
  end

  vertices[current].each { |neighbor, steps|
    next if visited.include?(neighbor)
    queue << [neighbor, path_steps + steps, visited | [neighbor]]
  }
end

puts "Max steps taken: #{max_steps_taken + final_steps}"