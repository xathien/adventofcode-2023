connections = {
  "|" => [[0, -1], [0, 1]],
  "-" => [[-1, 0], [1, 0]],
  "L" => [[0, -1], [1, 0]],
  "J" => [[0, -1], [-1, 0]],
  "7" => [[-1, 0], [0, 1]],
  "F" => [[1, 0], [0, 1]],
}
expanded_tile_map = {
  "|" => [[false, true, false], [false, true, false], [false, true, false]],
  "-" => [[false, false, false], [true, true, true], [false, false, false]],
  "L" => [[false, true, false], [false, true, true], [false, false, false]],
  "J" => [[false, true, false], [true, true, false], [false, false, false]],
  "7" => [[false, false, false], [true, true, false], [false, true, false]],
  "F" => [[false, false, false], [false, true, true], [false, true, false]],
}

current_pos = nil
grid = File.readlines('input')
    .map.with_index { |line, index|
      row = line.strip.chars
      start_col = row.index("S")
      current_pos = [start_col, index] if start_col
      row
    }

grid[current_pos[1]][current_pos[0]] = "|"

@expanded_grid = Array.new(grid.length * 3) { Array.new(grid[0].length * 3, false) }
loop_coords = Set.new
until current_pos.nil?
  loop_coords << current_pos
  x, y = current_pos
  exp_x, exp_y = x * 3, y * 3
  tile = grid[y][x]
  expanded_tile_map[tile].each_with_index { |mapping_row, dy|
    mapping_row.each_with_index { |mapped_val, dx|
      @expanded_grid[exp_y + dy][exp_x + dx] = mapped_val
    }
  }

  current_pos = nil
  connections[tile].each { |dx, dy|
    next_pos = [x + dx, y + dy]
    current_pos = next_pos unless loop_coords.include?(next_pos)
  }
end

outside_coords = Set.new
visited_coords = Set.new
@directions = [[0, -1], [0, 1], [-1, 0], [1, 0]]
@max_x = @expanded_grid[0].length - 1
@max_y = @expanded_grid.length - 1

def visit(coords, visited_coords, outside_coords, current_set)
  x, y = coords
  return true if outside_coords.include?(coords) || x < 0 || x > @max_x || y < 0 || y > @max_y
  return false if visited_coords.include?(coords) || @expanded_grid[y][x]

  visited_coords << coords
  current_set << coords
  @directions.each { |dx, dy|
    outside = visit([x + dx, y + dy], visited_coords, outside_coords, current_set)
    if outside
      outside_coords << coords
      return true
    end
  }
  false
end

current_set = Set.new
inside_coords = Set.new
grid.each_index { |y|
  grid[0].each_index { |x|
    outside = visit([x, y], visited_coords, outside_coords, current_set)
    inside_coords.merge(current_set) unless outside
    current_set.clear
  }
}

valid_inner_tiles = inside_coords.filter_map { |x, y|
  [x/3, y/3] unless loop_coords.include?([x/3, y/3])
}.uniq

puts "Tiles inside : #{valid_inner_tiles.size}"