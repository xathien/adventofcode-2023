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
  possible_midpoints = (0.5..(section[0].length - 1.5)).step(1.0).to_set
  section.each { |row|
    possible_midpoints.each { |midpoint|
      left = row[..midpoint.floor]
      right = row[midpoint.ceil..].take(left.length).reverse
      left = left.drop(left.length - right.length)
      unless left == right
        possible_midpoints.delete(midpoint)
      end
    }
  }
  found_midpoint = possible_midpoints.first
  sum += found_midpoint.ceil if found_midpoint
}
sum *= 100
sections.each_with_index { |section, index|
  possible_midpoints = (0.5..(section[0].length - 1.5)).step(1.0).to_set
  section.each { |row|
    possible_midpoints.each { |midpoint|
      left = row[..midpoint.floor]
      right = row[midpoint.ceil..].take(left.length).reverse
      left = left.drop(left.length - right.length)
      unless left == right
        possible_midpoints.delete(midpoint)
      end
    }
  }
  found_midpoint = possible_midpoints.first
  sum += found_midpoint.ceil if found_midpoint
}

puts "Sum: #{sum}"