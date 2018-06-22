require_relative 'tm/tape'

# The Turing Machine Configuration is the combination of the state and the tape.
# We can use Turing Machine rules that deal with these configurations.

# Let's implement a way to see if a rule applies to a given TM configuration.

class TMRule < Struct.new(:state, :character, :next_state, :write_character, :direction)
    def to_s
        "<struct TMRule state=#{state}, character=#{character}, next_state=#{next_state}, write_character=#{write_character}, direction=#{direction}>"
    end

    def applies_to?(configuration)
        configuration.state == state && configuration.tape.middle == character
    end
end

class TMConfiguration < Struct.new(:state, :tape)
end

# Verify the behaviour of the rule/combination

rule = TMRule.new(1, '0', 2, '1', :right)
puts rule
# <struct TMRule state=1, character="0", next_state=2, write_character="1", direction=:right>

puts rule.applies_to?(TMConfiguration.new(1, Tape.new([], '0', [], '_')))
# true

puts rule.applies_to?(TMConfiguration.new(1, Tape.new([], '1', [], '_')))
# false

puts rule.applies_to?(TMConfiguration.new(2, Tape.new([], '0', [], '_')))
# false
