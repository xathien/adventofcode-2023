class Hand
  CARD_VALUES = {
    "A" => "14",
    "K" => "13",
    "Q" => "12",
    "T" => "10",
    "9" => "09",
    "8" => "08",
    "7" => "07",
    "6" => "06",
    "5" => "05",
    "4" => "04",
    "3" => "03",
    "2" => "02",
    "J" => "01",
  }

  attr_reader :card_string, :bid

  def initialize(card_string, bid)
    @card_string = card_string
    @bid = bid
  end

  def hand_strength
    @hand_strength ||= calculate_hand_strength
  end

  def calculate_hand_strength
    tallies = card_string.chars.tally
    jokers = tallies.delete("J") || 0
    sorted_tallies = tallies.values.sort.reverse
    # All jokers, or 5 of a kind
    first_value = (sorted_tallies[0] || 0) + jokers
    hand_value = if first_value == 5
      70000000000
    elsif first_value == 4
      60000000000
    elsif first_value == 3 && sorted_tallies[1] == 2
      50000000000
    elsif first_value == 3
      40000000000
    elsif first_value == 2 && sorted_tallies[1] == 2
      30000000000
    elsif first_value == 2
      20000000000
    else
      10000000000
    end

    hand_value + card_string.chars.map { |c| CARD_VALUES[c] }.join.to_i
  end
end

hands = File.readlines('test_input')
    .map { |line|
      cards, bid = line.strip.split(" ")
      Hand.new(cards, bid.to_i)
    }

winnings = hands.sort_by! { |hand| hand.hand_strength }.each_with_index.reduce(0) { |acc, (hand, index)|
  acc + (hand.bid * (index + 1))
}
puts "Winnings: #{winnings}"