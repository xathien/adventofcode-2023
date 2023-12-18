require 'fc'

# grid = File.readlines("test_input")
grid = File.readlines("input")
  .map { |line|
    line.strip.chars.map(&:to_i)
  }

max_x = grid.first.size - 1
max_y = grid.size - 1

came_from = {}
g_scores = Hash.new { |h, k| h[k] = Float::INFINITY }
visited = Set.new
start_node = [0, 0, 1, 0, 0]
g_scores[start_node] = 0
heat_loss = nil
path = []

queue = FastContainers::PriorityQueue.new(:min)
queue.push(start_node, 0) # Right
until queue.empty?
  x, y, dx, dy, in_a_row = current = queue.pop
  next if visited.include?(current) # We've already visited this node going this direction

  g_score = g_scores[current]
  if x == max_x && y == max_y # We made it to the end! We'll go rebuild the route later if we need to
    heat_loss = g_score
    path << current
    while current = came_from[current]
      path << current
    end
    break
  end

  # Find available neighbors
  neighbors = [[x + dx, y + dy, dx, dy, in_a_row + 1]]
  if dy == 0 # We're moving horizontally, so we can turn up or down
    neighbors << [x, y - 1, 0, -1, 1] # Up
    neighbors << [x, y + 1, 0, 1, 1] # Down
  else # We're moving vertically, so we can turn left or right
    neighbors << [x - 1, y, -1, 0, 1] # Left
    neighbors << [x + 1, y, 1, 0, 1] # Right
  end

  neighbors.each { |neighbor|
    next_x, next_y, next_dx, next_dy, next_in_a_row = neighbor
    next if next_x < 0 || next_y < 0 || next_x > max_x || next_y > max_y || next_in_a_row > 3 # Out of bounds or too many in a row
    next_cost = grid[next_y][next_x]
    next_g_score = g_score + next_cost
    next if next_g_score >= g_scores[neighbor] # We've already found a better path to this node
    came_from[neighbor] = current
    g_scores[neighbor] = next_g_score
    # We'll guess that fewer tiles will generally yield lower heat loss
    distance_heuristic = next_g_score + (max_x - next_x + max_y - next_y)
    queue.push(neighbor, distance_heuristic)
  }
end

pp "Heat loss: #{heat_loss}"
pp "Path: #{path.reverse}"

path.each { |x, y, dx, dy, in_a_row|
  dir_symbol = case [dx, dy]
                when [0, -1] then "^"
                when [0, 1] then "v"
                when [-1, 0] then "<"
                when [1, 0] then ">"
                end
  grid[y][x] = dir_symbol
}
grid.each { |row| puts row.join }