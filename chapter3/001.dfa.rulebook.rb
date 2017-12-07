# implement the building blocks of a Deterministric Finite Automaton

# >> rulebook = DFARulebook.new([
#     FARule.new(1, 'a', 2), FARule.new(1, 'b', 1), FARule.new(2, 'a', 2), FARule.new(2, 'b', 3), FARule.new(3, 'a', 3), FARule.new(3, 'b', 3)
#     ])
#     => #<struct DFARulebook ...>
#     >> rulebook.next_state(1, 'a') => 2
#     >> rulebook.next_state(1, 'b') => 1
#     >> rulebook.next_state(2, 'b') => 3

# implementation

class FARule < Struct.new(:current_state, :character, :next_state)
end

class DFARulebook < Struct.new(:allowed_states)
    def next_state(state, character)
        rule_for(state, character).next_state
    end

    def rule_for(state, character)
        allowed_states.detect {|s| s.current_state == state and s.character == character}
    end
end

rulebook = DFARulebook.new([
    FARule.new(1, 'a', 2), FARule.new(1, 'b', 1), FARule.new(2, 'a', 2), FARule.new(2, 'b', 3), FARule.new(3, 'a', 3), FARule.new(3, 'b', 3)
    ])

puts rulebook.next_state(1, 'a')
puts rulebook.next_state(1, 'b')
puts rulebook.next_state(2, 'b')

# Output:

# 2
# 1
# 3
