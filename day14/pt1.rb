grid = File.readlines('test_input')
# grid = File.readlines('input')
  .map { |line|
    line.strip.chars
  }.transpose

total_load = 0
grid.each { |column|
  last_wall = -1
  column_length = column.length
  column.each_with_index { |sym, index|
    if sym == "O"
      total_load += column_length - last_wall - 1
      last_wall += 1
    elsif sym == "#"
      last_wall = index
    end
  }
}
puts "Total load: #{total_load}"