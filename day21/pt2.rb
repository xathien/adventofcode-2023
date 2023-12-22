start_pos = nil
multiplier = 5
# grid = File.readlines('test_input')
grid = File.readlines('input')
    .map.with_index { |line, index|
      row = line.strip.chars
      if start_pos.nil?
        start_col = row.index("S")
        offset = 131 * (multiplier / 2)
        start_pos = [start_col + offset, index + offset] if start_col
      end
      row.map { |c| c == "#" ? false : true } * multiplier
    } * multiplier

max_steps = 65 + 131 * (multiplier / 2)
# max_steps = 6 # Test input
final_plots = Set.new
visited = Set.new

puts "Start pos: #{start_pos}"
@dirs = [[0, -1], [0, 1], [-1, 0], [1, 0]]
@max_x = grid[0].size - 1
@max_y = grid.size - 1

# From the start_pos, recursively traverse the grid up to max_steps steps
# Return the maximum number of unique coordinates visited
def traverse(grid, state, final_plots, visited)
  x, y, steps_left = state
  if steps_left == 0
    final_plots << state
    return
  end

  visited << state
  @dirs.each { |dx, dy|
    next_x, next_y = x + dx, y + dy
    next_state = [next_x, next_y, steps_left - 1]
    next if visited.include?(next_state) || next_x < 0 || next_x > @max_x || next_y < 0 || next_y > @max_y || grid[next_y][next_x] == false
    traverse(grid, next_state, final_plots, visited)
  }
end

traverse(grid, start_pos + [max_steps], final_plots, visited)

# grid.each_with_index { |row, y|
#   row.each_with_index { |col, x|
#     if final_plots.include?([x, y, 0])
#       print "O"
#     else
#       print col ? "." : "#"
#     end
#   }
#   puts
# }

puts "Final plots: #{final_plots.size}"

n = 26501365 / 131
def term(n)
  a0 = 3752
  a1 = 33614
  a2 = 93252

  b0 = a0
  b1 = a1 - a0
  b2 = a2 - a1

  c0 = b2 - b1
  nth_term = b0 + (b1 * n) + ((n*(n-1)*c0)/2)
end
