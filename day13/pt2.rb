sections = []
section = []
# File.readlines('test_input')
File.readlines('input')
  .each { |line|
    line.strip!
    if line.empty?
      sections << section
      section = []
      next
    end

    section << line.chars.map { |c| c == "#" ? 1 : 0 }
  }

found_reflections_for = Set.new
sum = 0
transposed_sections = sections.map(&:transpose)
transposed_sections.each_with_index { |section, index|
  possible_midpoints = (0.5..(section[0].length - 1.5)).step(1.0).map { |midpoint| [midpoint, 0] }.to_h
  section.each { |row|
    possible_midpoints.each { |midpoint, error|
      left = row[..midpoint.floor]
      right = row[midpoint.ceil..].take(left.length).reverse
      left = left.drop(left.length - right.length)
      # puts "Left: #{left}, Right: #{right}"
      if left != right
        if error == 1
          possible_midpoints.delete(midpoint)
        else
          possible_midpoints[midpoint] = 1
        end
      end
    }
  }
  found_midpoint, _ = possible_midpoints.find { |midpoint, error| error == 1 }
  if found_midpoint
    sum += found_midpoint.ceil
    puts "Found vertical midpoint #{found_midpoint} at index #{index}"
    found_reflections_for << index
  end
}
sum *= 100
sections.each_with_index { |section, index|
  possible_midpoints = (0.5..(section[0].length - 1.5)).step(1.0).map { |midpoint| [midpoint, 0] }.to_h
  section.each { |row|
    possible_midpoints.each { |midpoint, error|
      left = row[..midpoint.floor]
      right = row[midpoint.ceil..].take(left.length).reverse
      left = left.drop(left.length - right.length)
      # puts "Left: #{left}, Right: #{right}"
      if left != right
        if error == 1
          possible_midpoints.delete(midpoint)
        else
          possible_midpoints[midpoint] = 1
        end
      end
    }
  }
  found_midpoint, _ = possible_midpoints.find { |midpoint, error| error == 1 }
  if found_midpoint
    sum += found_midpoint.ceil
    puts "Found horizontal midpoint #{found_midpoint} at index #{index}"
    found_reflections_for << index
  end
}

(0...sections.length).each { |index|
  puts "Missing reflection for #{index}" unless found_reflections_for.include?(index)
}
puts "Sum: #{sum}"