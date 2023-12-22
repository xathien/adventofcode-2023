# blocks = File.readlines('test_input')
blocks = File.readlines('input')
    .map.with_index { |line, index|
      x0, y0, z0, x1, y1, z1 = line.match(/(\d+),(\d+),(\d+)~(\d+),(\d+),(\d+)/).captures.map(&:to_i)
      block_num = index + 1
      [x0..x1, y0..y1, z0..z1, block_num]
    }.sort_by { |block| block[2].begin }

floor_levels = Hash.new { |h, k| h[k] = [0, nil] }
supporting = Hash.new { |h, k| h[k] = Set.new }
supported_by = Hash.new { |h, k| h[k] = Set.new }

blocks.each { |block|
  xr, yr, zr, block_num = block
  h = zr.end - zr.begin + 1
  floors = xr.flat_map { |x|
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

useless_blocks = 0
blocks.each_index { |index|
  block_num = index + 1
  supported = supporting[block_num]
  if supported.empty?
    useless_blocks += 1
  elsif supported.all? { |supportee| supported_by[supportee].size > 1 }
    useless_blocks += 1
  end
}

puts "Useless blocks: #{useless_blocks}"
