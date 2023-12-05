current_row = []
# [79, 14, 55, 13].each_slice(2) { |start, range|
[919339981, 562444630, 3366006921, 67827214, 1496677366, 101156779, 4140591657, 5858311, 2566406753, 71724353, 2721360939, 35899538, 383860877, 424668759, 3649554897, 442182562, 2846055542, 49953829, 2988140126, 256306471].each_slice(2) { |start, range|
  current_row << (start..(start + range - 1))
}

prev_row = []

File.readlines('input')
    .each { |line|
      line.strip!

      if line.empty?
        puts "Next conversion!"
        prev_row += current_row
        current_row = []
        next
      end

      puts "Processing line #{line}"
      dest_start, source_start, length = line.split(" ").map(&:to_i)
      source_end = source_start + length - 1
      dest_end = dest_start + length - 1
      # After each of these, prev_row will be a list of ranges that were not mapped
      prev_row = prev_row.flat_map { |range|
        # Check if this range intersects with source_start..source_end
        next range unless source_start <= range.end && source_end >= range.begin

        # Outer intersection
        if source_start <= range.begin && source_end >= range.end
          start_offset = range.begin - source_start
          end_offset = source_end - range.end
          current_row << ((dest_start + start_offset)..(dest_end - end_offset))
          next []
        end

        # Left intersection
        if source_start <= range.begin
          start_offset = range.begin - source_start
          current_row << ((dest_start + start_offset)..dest_end)
          next (source_end + 1)..range.end
        end

        # Right intersection
        if source_end >= range.end
          end_offset = source_end - range.end
          current_row << (dest_start..(dest_end - end_offset))
          next range.begin..(source_start - 1)
        end

        # Inner intersection
        current_row << (dest_start..dest_end)
        [range.begin..(source_start - 1), (source_end + 1)..range.end]
      }
      puts "After step: #{prev_row}"
      puts "After step 2: #{current_row}"
    }

current_row += prev_row
pp "All: #{current_row}"
puts "Lowest: #{current_row.min_by(&:begin).begin}"