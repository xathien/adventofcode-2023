dir = "LRRLLRLLRRLRRLLRRLLRLRRRLLRRLRRRLRRLRRRLLRRLLRLLRRLRLRRRLRRLLRRRLRLRRLRRLRLRLRLLRLRRRLLRLLRRLRRRLRLRLRRRLRRLLRRRLRLRRLRRLLRRLRRRLRRLRRLRRLLRLRLRRLLRLLRRRLRRLRRLRRRLRLLRRRLRRRLRRLLRRRLRRRLRLLRLRRLRLLRRLLLRRLRRLRRLRLRRRLRRLLRLRRRLRRLRLLLRRLRRLRRRLLLRLLLLRRLRLLLRLRRRLRRRLRLRRRLLLLRLRRRLRLLLRRLRLRRLRRLRRRLRRRR".chars.cycle
nodes = {}
File.readlines('input')
    .each { |line|
      node, left, right = line.strip.split(" ")
      nodes[node] = [left, right]
    }

node = "AAA"
steps = 0
until node == "ZZZ"
  steps += 1
  direction = dir.next
  node = nodes[node][direction == "L" ? 0 : 1]
end

puts "Steps: #{steps}"