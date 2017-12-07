# Once we have a rulebook, we can use it to build a DFA object that keeps track of its current state and can report whether it’s currently in an accept state or not.

# assignment: create a Deterministic Finite Automaton according to the following inspection and output

# >> dfa = DFA.new(1, [3], rulebook); dfa.accepting? => false
# >> dfa.read_character('b'); dfa.accepting?
# => false
# >> 3.times do dfa.read_character('a') end; dfa.accepting? => false
# >> dfa.read_character('b'); dfa.accepting?
# => true

class DFA < Struct.new(:current_state, :accept_states, :rulebook)
    def accepting?
        accept_states.include?(self.current_state)
    end

    def read_character(character)
        self.current_state = rulebook.next_state(self.current_state, character)
    end
end

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

dfa = DFA.new(1, [3], rulebook); puts dfa.accepting?
dfa.read_character('b'); puts dfa.accepting?
3.times do dfa.read_character('a') end; puts dfa.accepting?
dfa.read_character('b'); puts dfa.accepting?

# Output:

# false
# false
# false
# true
