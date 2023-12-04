sum = File.readlines('input')
    .map(&:strip)
    .sum { |line|
      winning, numbers = line.split(" | ")
      winning = winning.split(" ").map(&:to_i).to_set
      matches = numbers.split(" ").map(&:to_i).count { |number| winning.include?(number) }
      matches == 0 ? 0 : 2**(matches - 1)
    }

puts "Sum: #{sum}"