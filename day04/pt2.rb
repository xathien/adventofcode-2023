card_copies = Array.new(213, 1)
File.readlines('input')
    .map(&:strip)
    .each_with_index { |line, index|
      winning, numbers = line.split(" | ")
      winning = winning.split(" ").map(&:to_i).to_set
      matches = numbers.split(" ").map(&:to_i).count { |number| winning.include?(number) }
      my_copies = card_copies[index]
      while matches > 0
        card_copies[index + matches] += my_copies
        matches -= 1
      end
    }

puts "Sum: #{card_copies.sum}"