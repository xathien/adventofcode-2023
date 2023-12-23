require 'fc'

# grid = File.readlines("test_input")
grid = File.readlines("input")
  .map { |line|
    line.strip!.chars
  }

max_x = grid.first.size - 1
max_y = grid.size - 1

came_from = {}
g_scores = Hash.new { |h, k| h[k] = -Float::INFINITY }
visited = Set.new
start_node = [1, 0, 1, -1]
g_scores[[1, 0]] = 0
path = []
directions = [[0, -1], [0, 1], [-1, 0], [1, 0]]
final_steps_taken = nil
last_coords = nil

queue = FastContainers::PriorityQueue.new(:max)
queue.push(start_node, 0)
until queue.empty?
  x, y, prev_x, prev_y = queue.pop
  current = [x, y]
  g_score = g_scores[current]
  if y == max_y # We made it to the end! We'll go rebuild the route later if we need to
    final_steps_taken = g_score
    last_coords = [x, y]
    next
  end

  # Find available neighbors
  neighbors = case grid[y][x]
    when "." # We can move in any direction
      directions.map { |dx, dy| [x + dx, y + dy] }
    when "^" # We can only move up
      [[x, y - 1]]
    when "v" # We can only move down
      [[x, y + 1]]
    when "<" # We can only move left
      [[x - 1, y]]
    when ">" # We can only move right
      [[x + 1, y]]
    end

  neighbors.each { |neighbor|
    next_x, next_y = neighbor
    next if next_x < 0 || next_y < 0 || next_x > max_x || next_y > max_y || grid[next_y][next_x] == "#" ||
      (next_x == prev_x && next_y == prev_y)
    next_g_score = g_score + 1
    next if next_g_score <= g_scores[neighbor] # We've already found a better path to this node
    came_from[neighbor] = current
    g_scores[neighbor] = next_g_score
    distance_heuristic = next_g_score
    queue.push(neighbor + [x, y], distance_heuristic)
  }
end

path << last_coords
while last_coords = came_from[last_coords]
  path << last_coords
end

pp "Final steps taken: #{final_steps_taken}"

path_set = Set.new(path)
grid.each_with_index { |row, y|
  row.each_with_index { |cell, x|
    if path_set.include?([x, y])
      print "O"
    else
      print cell
    end
  }
  puts
}
