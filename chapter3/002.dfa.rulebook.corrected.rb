# correct the implementation of the previous sample (1.dfa.rulebook.rb) with the materials from the book

class FARule < Struct.new(:current_state, :character, :next_state)
    def applies_to?(state, character)
        self.current_state == state and self.character == character
    end

    def follow
        next_state
    end

    def inspect
        "#<FARule #{state.inspect} --#{character}--> #{next_state.inspect}>"
    end
end

class DFARulebook < Struct.new(:allowed_states)
    def next_state(state, character)
        rule_for(state, character).follow
    end

    def rule_for(state, character)
        allowed_states.detect {|s| s.applies_to?(state, character)}
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
