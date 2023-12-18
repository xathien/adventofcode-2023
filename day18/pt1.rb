grid = {}
x, y, min_x, min_y, max_x, max_y = 0, 0, 0, 0, 0, 0
grid[[x, y]] = true

# File.readlines("test_input")
File.readlines("input")
  .map { |line|
    dir, count = line.strip.split(" ")
    count = count.to_i
    count.times {
      case dir
      when "U"
        y -= 1
      when "D"
        y += 1
      when "L"
        x -= 1
      when "R"
        x += 1
      end

      min_x = x if x < min_x
      min_y = y if y < min_y
      max_x = x if x > max_x
      max_y = y if y > max_y
      grid[[x, y]] = true
    }
  }

# interior_start = [min_x + 1, min_y + 1] # Test
interior_start = [min_x + 230, min_y + 1]

queue = [interior_start]
while (x, y = queue.shift)
  next if grid[[x, y]]
  grid[[x, y]] = true
  queue << [x + 1, y]
  queue << [x - 1, y]
  queue << [x, y + 1]
  queue << [x, y - 1]
end

(min_y..max_y).each { |y|
  (min_x..max_x).each { |x|
    print grid[[x, y]] ? "#" : "."
  }
  puts
}

puts "Size: #{grid.size}"