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

def parse_number(row, row_num, index, prev_row, next_row)
  char = row[index]
  if char.nil? || char.ord < @zero_ord || char.ord > @nine_ord
    return "", false
  end

  prev_col = index - 1
  next_col = index + 1
  is_part_num = symbol?(prev_row, prev_col) || symbol?(prev_row, index) || symbol?(prev_row, next_col) ||
    symbol?(row, prev_col) || symbol?(row, next_col) ||
    symbol?(next_row, prev_col) || symbol?(next_row, index) || symbol?(next_row, next_col)

  rec_digits, rec_part_num = parse_number(row, row_num, index + 1, prev_row, next_row)
  [char + rec_digits, rec_part_num || is_part_num]
end

def symbol?(row, col_index)
  return false if row.nil?

  char = row[col_index]
  return false if col_index < @first_col || col_index > @last_col

  char_ord = row[col_index].ord
  result = (char_ord < @zero_ord || char_ord > @nine_ord) && char != "."
  result
end


sum = 0
@matrix.each_with_index { |row, row_num|
  index = 0
  prev_row = row_num > @first_row ? @matrix[row_num - 1] : nil
  next_row = row_num < @last_row ? @matrix[row_num + 1] : nil
  while index < row.length
    num_str, is_part_num = parse_number(row, row_num, index, prev_row, next_row)
    puts "num_str: #{num_str}, is_part_num: #{is_part_num}" unless num_str == ""
    sum += num_str.to_i if is_part_num
    index += 1 + num_str.size
  end
}

pp "Sum? #{sum}"