max_times = [40929790]
max_distances = [215106415051100]
races = max_times.zip(max_distances)

result = races.reduce(1) { |product, (time, distance)|
  sqrt = Math.sqrt(time*time - 4 * distance)
  left_bound = ((time - sqrt)/2).ceil
  right_bound = ((time + sqrt)/2).floor
  product * (right_bound - left_bound + 1)
}

puts "Product: #{result}"
