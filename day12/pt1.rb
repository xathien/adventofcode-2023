total_possibilities = 0
scan_regex = /[^.]+/
# File.readlines('test_input')
File.readlines('input')
  .each { |line|
    springs, groups = line.strip.split(" ")
    groups = groups.split(",").map(&:to_i)
    unknown_indices = springs.chars.each_index.select{ |i| springs[i] == "?" }
    num_permutations = 2 ** unknown_indices.length
    puts "Total permutations: #{line} => #{num_permutations}"
    permutations = (0...num_permutations).map { |i|
      unknown_indices.each_with_index { |q_idx, bit_idx|
        springs[q_idx] = i[bit_idx] == 0 ? "." : "#"
      }
      group_sizes = springs.scan(scan_regex).map(&:size)
      total_possibilities += 1 if group_sizes == groups
    }
  }

puts "Total possibilities: #{total_possibilities}"
