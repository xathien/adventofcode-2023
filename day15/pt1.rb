# line = File.read('test_input').strip!
line = File.read('input').strip!
sum = line.split(",").sum { |part|
  current_value = 0
  part.chars.each_with_index { |char, index|
    current_value += (char.ord) * (17 ** (part.length - index))
    current_value %= 256
  }
  current_value
}
puts "Sum: #{sum}"
