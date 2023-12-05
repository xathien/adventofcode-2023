current_row = [919339981, 562444630, 3366006921, 67827214, 1496677366, 101156779, 4140591657, 5858311, 2566406753, 71724353, 2721360939, 35899538, 383860877, 424668759, 3649554897, 442182562, 2846055542, 49953829, 2988140126, 256306471]
# current_row = [79, 14, 55, 13]

prev_row = nil

File.readlines('input')
    .each { |line|
      line.strip!

      if line.empty?
        prev_row = current_row
        current_row = prev_row.dup
        next
      end

      dest_start, source_start, length = line.split(" ").map(&:to_i)
      source_end = source_start + length - 1
      prev_row.each_with_index { |number, index|
        if number >= source_start && number <= source_end
          new_number = dest_start + (number - source_start)
          current_row[index] = new_number
        end
      }
    }

pp "All: #{current_row}"
puts "Lowest: #{current_row.min}"