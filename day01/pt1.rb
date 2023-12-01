require 'set'

sum = File.readlines('input')
    .map(&:strip)
    .sum do |line|
      digits = line.scan(/\d/)
      first_digit = digits.first.to_i
      last_digit = digits.last.to_i

      (10 * first_digit) + last_digit
    end

pp "Sum? #{sum}"