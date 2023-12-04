require "pry"


symbol_positions = Set.new
numbers = Set.new
part_nums = Set.new

@zero_ord = "0".ord.freeze
@nine_ord = "9".ord.freeze

@matrix = File.readlines('input')
    .map(&:strip)
    .map(&:chars)

@first_row = 0
@last_row = @matrix.size - 1
@first_col = 0
@last_col = @matrix[0].size - 1

def digit?(char)
  char.ord >= @zero_ord && char.ord <= @nine_ord
end

def find_num(row, index)
  char = row[index]
  return nil, index unless digit?(char)

  end_index = index
  num_str = char
  prev_char = row[index - 1]
  if index > @first_col && digit?(prev_char)
    num_str = prev_char + num_str if index > @first_col && digit?(prev_char)
    prev_char = row[index - 2]
    num_str = prev_char + num_str if index - 1 > @first_col && digit?(prev_char)
  end
  next_char = row[index + 1]
  if digit?(next_char)
    num_str << next_char
    end_index += 1
    next_char = row[index + 2]
    if digit?(next_char)
      num_str << next_char
      end_index += 1
    end
  end

  return num_str.to_i, end_index
end

sum = 0
@matrix.each_with_index { |row, row_num|
  prev_row = row_num > @first_row ? @matrix[row_num - 1] : nil
  next_row = row_num < @last_row ? @matrix[row_num + 1] : nil
  row.each_with_index { |char, index|
    next unless char == "*"

    numbers = []
    num, end_index = find_num(prev_row, index - 1)
    numbers << num
    if end_index < index + 1
      num, end_index = find_num(prev_row, end_index + 1)
      numbers << num
      if end_index < index + 1
        num, end_index = find_num(prev_row, end_index + 1)
        numbers << num
      end
    end

    num, _ = find_num(row, index - 1)
    numbers << num
    num, _ = find_num(row, index + 1)
    numbers << num
    num, end_index = find_num(next_row, index - 1)
    numbers << num
    if end_index < index + 1
      num, end_index = find_num(next_row, end_index + 1)
      numbers << num
      if end_index < index + 1
        num, end_index = find_num(next_row, end_index + 1)
        numbers << num
      end
    end

    puts "Adjacent numbers for #{row_num}, #{index}: #{numbers}"
    numbers.compact!
    if numbers.size == 2
      sum += numbers.reduce(:*)
    end
  }
}

pp "Sum? #{sum}"