class Hand
  CARD_VALUES = {
    "A" => "14",
    "K" => "13",
    "Q" => "12",
    "J" => "11",
    "T" => "10",
    "9" => "09",
    "8" => "08",
    "7" => "07",
    "6" => "06",
    "5" => "05",
    "4" => "04",
    "3" => "03",
    "2" => "02",
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
    sorted_tallies = card_string.chars.tally.values.sort.reverse
    hand_value = if sorted_tallies[0] == 5
      70000000000
    elsif sorted_tallies[0] == 4
      60000000000
    elsif sorted_tallies[0] == 3 && sorted_tallies[1] == 2
      50000000000
    elsif sorted_tallies[0] == 3
      40000000000
    elsif sorted_tallies[0] == 2 && sorted_tallies[1] == 2
      30000000000
    elsif sorted_tallies[0] == 2
      20000000000
    else
      10000000000
    end

    hand_value + card_string.chars.map { |c| CARD_VALUES[c] }.join.to_i
  end
end

hands = File.readlines('input')
    .map { |line|
      cards, bid = line.strip.split(" ")
      Hand.new(cards, bid.to_i)
    }

winnings = hands.sort_by! { |hand| hand.hand_strength }.each_with_index.reduce(0) { |acc, (hand, index)|
  acc + (hand.bid * (index + 1))
}
puts "Winnings: #{winnings}"