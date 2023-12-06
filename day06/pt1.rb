max_times = [40, 92, 97, 90]
max_distances = [215, 1064, 1505, 1100]
races = max_times.zip(max_distances)

result = races.reduce(1) { |product, (time, distance)|
  sqrt = Math.sqrt(time*time - 4 * distance)
  left_bound = ((time - sqrt)/2).ceil
  right_bound = ((time + sqrt)/2).floor
  product * (right_bound - left_bound + 1)
}

puts "Product: #{result}"
