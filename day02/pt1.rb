require 'set'

colors = {
  "red" => 12,
  "green" => 13,
  "blue" => 14,
}

sum = 0
File.readlines('input')
    .map(&:strip)
    .each_with_index { |line, index|
      not_possible = false
      draws = line.split(";")
      draws.each { |draw|
        sets = draw.split(",")
        sets.each { |set|
          set = set.split(" ")
          num = set[0].to_i
          color = set[1]
          not_possible = true if num > colors[color]
        }
      }
      sum += (index + 1) unless not_possible
    }

pp "Sum? #{sum}"