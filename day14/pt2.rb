# grid = File.readlines('test_input')
grid = File.readlines('input')
  .map { |line|
    line.strip.chars
  }

seen_states = {}
cycle = 0
grid_size = grid.length
until seen_states.key?(grid)
  seen_states[grid] = cycle

  # Get a fresh copy
  grid = grid.map(&:dup)
  cycle += 1

  # North
  grid_size.times { |x|
    last_wall = -1
    grid_size.times { |y|
      sym = grid[y][x]
      if sym == "O"
        last_wall += 1
        grid[y][x] = "."
        grid[last_wall][x] = "O"
      elsif sym == "#"
        last_wall = y
      end
    }
  }

  # West
  grid.each { |column|
    last_wall = -1
    column.each_with_index { |sym, index|
      if sym == "O"
        last_wall += 1
        column[index] = "."
        column[last_wall] = "O"
      elsif sym == "#"
        last_wall = index
      end
    }
  }

  # South
  grid_size.times { |x|
    last_wall = grid_size
    (grid_size - 1).downto(0) { |y|
      sym = grid[y][x]
      if sym == "O"
        last_wall -= 1
        grid[y][x] = "."
        grid[last_wall][x] = "O"
      elsif sym == "#"
        last_wall = y
      end
    }
  }

  # East
  grid.each { |column|
    last_wall = grid_size
    column.each_with_index.reverse_each { |sym, index|
      if sym == "O"
        last_wall -= 1
        column[index] = "."
        column[last_wall] = "O"
      elsif sym == "#"
        last_wall = index
      end
    }
  }

end

loop_start = seen_states[grid]
loop_end = cycle
max_cycles = 1000000000
after_loop_start = max_cycles - loop_start
loop_length = loop_end - loop_start
cycles_into_loop = after_loop_start % loop_length
target_cycle = loop_start + cycles_into_loop
final_grid = seen_states.find { |_, cycle| cycle == target_cycle }[0]
total_load = 0
final_grid.each_with_index { |row, index|
  row.each { |sym|
    next unless sym == "O"
    total_load += grid_size - index
  }
}

puts "Total load: #{total_load}"