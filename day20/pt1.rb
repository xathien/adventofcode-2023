class Module
  def initialize(name, targets)
    @name = name
    @targets = targets
  end

  attr_reader :queue, :name, :targets
  def process(from_name, high)
    signal = handle_signal(from_name, high)
    return [] if signal.nil?
    targets.map { |target|
      [name, target, signal]
    }
  end

  def state
    nil
  end
end

class Broadcaster < Module
  def handle_signal(_from_name, high)
    high
  end
end

class FlipFlop < Module
  def initialize(name, targets)
    super
    @state = false
  end

  attr_reader :state

  def handle_signal(_from_name, high)
    return nil if high
    @state ^= true
  end
end

class Conjunction < Module
  def initialize(name, targets)
    super
    @state = {}
  end

  attr_accessor :state

  def handle_signal(from_name, high)
    state[from_name] = high
    return false if state.values.all? { |high| high }
    true
  end
end

class Nothing < Module
  def handle_signal(_from_name, _high)
    nil
  end
end

modules = Hash.new { |h, k| h[k] = Nothing.new(k, []) }

# File.readlines("test_input2")
File.readlines("input")
  .map { |line|
    type, name, targets = line.strip.match(/([*%&])([a-z]+) -> (.+)/).captures
    targets = targets.split(", ")
    klass = case type
            when "*" then Broadcaster
            when "%" then FlipFlop
            when "&" then Conjunction
            end
    modules[name] = klass.new(name, targets)
  }

# Default all Conjunctions to "low" for all inputs
all_conjunctions = modules.values.filter_map { |mod|
  next unless mod.is_a?(Conjunction)
  mod.name
}.to_set
modules.values.each { |mod|
  from_name = mod.name
  mod.targets.each { |target|
    next unless all_conjunctions.include?(target)
    modules[target].handle_signal(from_name, false)
  }
}

broadcaster = modules["broadcaster"]
total_pulses_sent = { false => 0, true => 0 }
(0...1000).each { |i|
  current_pulses = { false => 0, true => 0 }
  process_queue = [["button", "broadcaster", false]]
  while (from_name, target, high = process_queue.shift)
    current_pulses[high] += 1
    process_queue.concat(modules[target].process(from_name, high))
  end
  total_pulses_sent[false] += current_pulses[false]
  total_pulses_sent[true] += current_pulses[true]
}

puts "Total pulse value: #{total_pulses_sent[false] * total_pulses_sent[true]}"
