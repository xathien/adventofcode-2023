# blocks = File.readlines('test_input')
blocks = File.readlines('input')
    .map.with_index { |line, index|
      x0, y0, z0, x1, y1, z1 = line.match(/(\d+),(\d+),(\d+)~(\d+),(\d+),(\d+)/).captures.map(&:to_i)
      axis = case
      when x0 != x1 then 0
      when y0 != y1 then 1
      when z0 != z1 then 2
      end
      block_num = index + 1
      block = [x0..x1, y0..y1, z0..z1, block_num]
    }.sort_by { |block| block[2].begin }

floor_levels = Hash.new { |h, k| h[k] = [0, nil] }
supporting = Hash.new { |h, k| h[k] = Set.new }
supported_by = Hash.new { |h, k| h[k] = Set.new }

blocks.each { |block|
  xr, yr, zr, block_num = block
  h = zr.end - zr.begin + 1
  highest_floor = 0
  floors = xr.flat_map{ |x|
    yr.map { |y|
      floor_levels[[x, y]] + [x, y]
    }
  }
  highest_block = floors.map(&:first).max
  floors.each { |level, supporting_block_num, x, y|
    floor_levels[[x, y]] = [highest_block + h, block_num]
    if level == highest_block && supporting_block_num
      supporting[supporting_block_num] << block_num
      supported_by[block_num] << supporting_block_num
    end
  }
}

falling_blocks = blocks.each_index.sum { |index|
  block_num = index + 1
  falling_set = Set.new([block_num])
  queue = supporting[block_num].to_a
  while supportee = queue.shift
    next unless !falling_set.include?(supportee) && supported_by[supportee] <= falling_set
    falling_set << supportee
    queue.concat(supporting[supportee].to_a)
  end
  falling_set.size - 1
}

puts "Falling blocks: #{falling_blocks}"