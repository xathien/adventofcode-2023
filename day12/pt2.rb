@states_seen = {}

def cache_solve(springs, groups)
  memoized = @states_seen[[springs, groups]]
  return memoized if memoized
  @states_seen[[springs, groups]] = sub_solve(springs, groups)
end

def sub_solve(springs, groups)
  if springs.empty?
    return groups.empty? ? 1 : 0
  end

  current_char = springs[0]
  current_group = groups[0]
  if current_char == "#"
    # No more groups || not enough springs left to finish this group || the group is too small || the group is too large
    return 0 if current_group.nil? || springs.length < current_group ||
      (0...current_group).any? { |i| springs[i] == "." } || springs[current_group] == "#"

    # We know the group has to terminate here, so we can skip the next unknown
    return cache_solve(springs[(current_group + 1)..], groups[1..]) if springs.length > current_group && springs[current_group] == "?"

    # Skip to the start of the next group
    cache_solve(springs[current_group..], groups[1..])
  elsif current_char == "."
    cache_solve(springs[1..], groups)
  elsif current_char == "?"
    # Try both
    cache_solve("#" + springs[1..], groups) + cache_solve(springs[1..], groups)
  end
end

# File.readlines('test_input')
total_possibilities = File.readlines('input')
  .sum { |line|
    springs, groups = line.strip.split(" ")
    springs = ((springs + "?")*5)[0...-1]
    groups = groups.split(",").map(&:to_i) * 5

    cache_solve(springs, groups)
  }

puts "Total possibilities: #{total_possibilities}"
