require 'set'

def convert(digit, pos)
  case digit
  when 'one'
    1
  when 'two'
    2
  when 'three'
    3
  when 'four'
  4
  when 'five'
  5
  when 'six'
    6
  when 'seven'
    7
  when 'eight'
    8
  when 'nine'
    9
  when 'oneight'
    [1, 8][pos]
  when 'threeight'
    [3, 8][pos]
  when 'fiveight'
    [5, 8][pos]
  when 'twone'
    [2, 1][pos]
  when 'nineight'
    [9, 8][pos]
  when 'sevenine'
    [7, 9][pos]
  when 'eighthree'
    [8, 3][pos]
  when 'eightwo'
    [8, 2][pos]
  else
    digit.to_i
  end
end

sum = File.readlines('input')
    .map(&:strip)
    .sum do |line|
      digits = line.scan(/\d|oneight|threeight|nineight|fiveight|twone|sevenine|eighthree|eightwo|one|two|three|four|five|six|seven|eight|nine/)
      first_digit = convert(digits.first, 0)
      last_digit = convert(digits.last, 1)

      (10 * first_digit) + last_digit
    end

pp "Sum? #{sum}"