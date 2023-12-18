x, y = 0, 0
perimeter = 0
area = 0

# File.readlines("test_input")
File.readlines("input")
  .each { |line|
    count, dir = line.scan(/(?<=#)(.....)(.)/)[0]
    count = count.to_i(16)
    perimeter += count
    next_x, next_y = x, y
    case dir
    when "0"
      next_x += count
    when "1"
      next_y += count
    when "2"
      next_x -= count
    when "3"
      next_y -= count
    end
    # Shoelace formula
    area += (next_x + x) * (next_y - y)
    x, y = next_x, next_y
  }

total_area = (area + perimeter) / 2 + 1 # Pick's theorem
puts "Total area: #{total_area}"