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
    if name == "kl"
      @presses = 0
      @last_high = {}
      @loop_lengths = {}
      parents = ["mk", "fp", "xt", "zc"]
      parents.each { |parent|
        @last_high[parent] = nil
        @loop_lengths[parent] = nil
      }
    end
  end

  attr_accessor :state

  def handle_signal(from_name, high)
    state[from_name] = high
    if name == "kl" && high
      last_high = @last_high[from_name] ||= @presses
      if last_high != @presses && @loop_lengths[from_name].nil?
        loop_length = @loop_lengths[from_name] = @presses - last_high
        puts "#{from_name} loop length: #{loop_length}"
      end
    end
    return false if all_high?
    true
  end

  def all_high?
    state.values.all? { |high| high }
  end

  def inc_presses
    @presses += 1
  end

  def all_done?
    @loop_lengths.values.none?(&:nil?)
  end
end

class Nothing < Module
  def handle_signal(_from_name, high)
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
kl = modules["kl"]
(1..).each { |i|
puts "Step #{i}" if i % 10000 == 0
  kl.inc_presses
  process_queue = [["button", "broadcaster", false]]
  while (from_name, target, high = process_queue.shift)
    # puts "#{from_name} -#{high ? "high" : "low"}-> #{target}"
    process_queue.concat(modules[target].process(from_name, high))
  end

  if kl.all_done?
    puts "Finished in #{i} steps"
    break
  end
}