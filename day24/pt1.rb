# line_segments = File.readlines("test_input")
line_segments = File.readlines("input")
  .map { |line|
    x0, y0, z0, vx, vy, vz = line.strip!.match(/(\d+),\s*(\d+),\s*(\d+)\s*@\s*(-?\d+),\s*(-?\d+),\s*(-?\d+)/).captures.map(&:to_i)
    x1, y1 = x0 + vx, y0 + vy
    puts "Line: #{line} => (#{x0}, #{y0}), (#{x1}, #{y1})"
    [[x0, y0], [x1, y1]]
  }

puts "Line segments:"
pp line_segments

def det(a, b)
  a[0] * b[1] - a[1] * b[0]
end

# Return intersecting point if lines intersect, nil otherwise
def intersect?(line1, line2)
	dx = [line1[0][0] - line1[1][0], line2[0][0] - line2[1][0]]
	dy = [line1[0][1] - line1[1][1], line2[0][1] - line2[1][1]]
  div = det(dx, dy)
	return [nil, nil] if div.zero? # Parallel lines

	d = [det(*line1), det(*line2)]
	x = det(d, dx) / div
	y = det(d, dy) / div
	return x, y
end

def intersect_in_future?(line1, line2, coord_range)
  x, y = intersect?(line1, line2)
  return false unless x && y && coord_range.include?(x) && coord_range.include?(y)

  # Make sure it happened in the future by comparing dx with vx and dy with vy
  dx = x - line1[0][0]
  dy = y - line1[0][1]
  vx = line1[1][0] - line1[0][0]
  vy = line1[1][1] - line1[0][1]
  return false unless (dx > 0) == (vx > 0) && (dy > 0) == (vy > 0)

  dx = x - line2[0][0]
  dy = y - line2[0][1]
  vx = line2[1][0] - line2[0][0]
  vy = line2[1][1] - line2[0][1]
  return false unless (dx > 0) == (vx > 0) && (dy > 0) == (vy > 0)

  true
end

coord_range = 200000000000000..400000000000000
# coord_range = 7..27 # Test input
# Compare each line segment to each other line segment for intersection
intersections = 0
intersections = line_segments.combination(2).count { |line1, line2|
  yes = intersect_in_future?(line1, line2, coord_range)
  # puts "Intersect? #{line1} #{line2} => #{yes}"
  yes
}

puts "Intersections: #{intersections}"