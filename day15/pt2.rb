# line = File.read('test_input').strip!
line = File.read('input').strip!
boxes = Array.new(256) { Hash.new }
line.split(",").each { |part|
  current_value = 0
  part_length = part.index("=") || part.index("-") || part.length
  part_label = part[...part_length]
  part_label.chars.each_with_index { |char, index|
    current_value += (char.ord) * (17 ** (part_length - index))
    current_value %= 256
  }
  op = part[part_length]
  if op == "="
    lens_value = part[part_length + 1].to_i
    boxes[current_value][part_label] = lens_value
  else # op == "-"
    boxes[current_value].delete(part[part_label])
  end
}

boxes_total = 0
boxes.each_with_index { |box, index|
  box_value = index + 1
  box.values.each_with_index { |focus, lens_index|
    boxes_total += box_value * focus * (lens_index + 1)
  }
}
puts "Sum: #{boxes_total}"
