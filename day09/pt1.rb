predictions = File.readlines('input')
    .sum { |line|
      rows = [line.strip.split(" ").map(&:to_i)]
      rows.each { |row|
        next_row = Array.new(row.length - 1, 0)
        row.drop(1).each_with_index { |number, index|
          prev_number = row[index]
          next_row[index] = number - prev_number
        }
        rows << next_row unless next_row.all?(&:zero?)
      }
      predicted = 0
      rows.reverse_each { |row|
        predicted += row.last
      }
      puts "Predicted: #{predicted}"
      predicted
    }

puts "Predictions: #{predictions}"