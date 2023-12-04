require 'set'

colors = {
  "red" => 0,
  "green" => 0,
  "blue" => 0,
}

sum = File.readlines('input')
    .map(&:strip)
    .sum { |line|
      min_colors = colors.dup
      draws = line.split(";")
      draws.each { |draw|
        sets = draw.split(",")
        sets.each { |set|
          set = set.split(" ")
          num = set[0].to_i
          color = set[1]
          min_colors[color] = num if min_colors[color] < num
        }
      }
      product = min_colors.values.reduce(:*)
      pp "Product: #{product}"
      product
    }

pp "Sum? #{sum}"