grid_size = 140
# grid_size = 10 # Test data
empty_rows = (0...grid_size).to_set
empty_cols = (0...grid_size).to_set
galaxy_coords = []

File.readlines('input')
  .each_with_index { |line, row_i|
    row = line.strip.chars
    galaxy_indexes = row.each_index.select{ |col_i| row[col_i] == "#" }
    galaxy_indexes.each { |col_i|
      empty_rows.delete(row_i)
      empty_cols.delete(col_i)
      galaxy_coords << [col_i, row_i]
    }
  }

galaxy_coords.each_with_index { |(x, y), i|
  expanded_cols = empty_cols.count { |col_i| col_i < x }
  expanded_rows = empty_rows.count { |row_i| row_i < y }
  galaxy_coords[i] = [x + (expanded_cols * 999999), y + (expanded_rows * 999999)]
}

total_distance = 0
galaxy_coords.each_with_index { |(x1, y1), i|
  galaxy_coords.drop(i).each { |x2, y2|
    total_distance += (x1 - x2).abs + (y1 - y2).abs
  }
}

puts "Total distance: #{total_distance}"