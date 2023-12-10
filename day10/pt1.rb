connections = {
  "|" => [[0, -1], [0, 1]],
  "-" => [[-1, 0], [1, 0]],
  "L" => [[0, -1], [1, 0]],
  "J" => [[0, -1], [-1, 0]],
  "7" => [[-1, 0], [0, 1]],
  "F" => [[1, 0], [0, 1]],
  "S" => [[0, -1], [0, 1]],
}

start_pos = nil
grid = File.readlines('input')
    .map.with_index { |line, index|
      row = line.strip.chars
      start_col = row.index("S")
      start_pos = [start_col, index] if start_col
      row
    }

current_pos = start_pos
prev_pos = current_pos
distance = 1
current_pos[0] -= 1 # Go up one to start
done = false
until done
  x, y = current_pos
  dirs = connections[grid[y][x]]
  next_pos = nil
  dirs.each { |dx, dy|
    next_pos = [x + dx, y + dy]
    break unless next_pos == prev_pos
  }
  distance += 1
  prev_pos = current_pos
  current_pos = next_pos
  done = current_pos == start_pos
end

puts "Loop length: #{distance}"