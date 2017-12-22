require 'set'

class FARule < Struct.new(:current_state, :character, :next_state)
    def applies_to?(state, character)
        self.current_state == state and self.character == character
    end

    def follow
        next_state
    end

    def inspect
        "#<FARule #{current_state.inspect} --#{character}--> #{next_state.inspect}>"
    end
end

class NFARulebook < Struct.new(:rules)
    def follow_free_moves(states)
        more_states = next_states(states, nil)
        
        if more_states.subset?(states) 
            states
        else
            follow_free_moves(states + more_states) 
        end
    end

    def next_states(states, character)
        states.flat_map{ |state| follow_rule(state, character) }.to_set
    end

    def follow_rule(state, character)
        rules_applies_for(state, character).map(&:follow)
    end

    def rules_applies_for(state, character)
        rules.select {|rule| rule.applies_to?(state, character)}
    end
end

class NFA < Struct.new(:current_states, :accept_states, :rulebook)
    def current_states
        rulebook.follow_free_moves(super) 
    end

    def accepting?
        (current_states & accept_states).any?
    end

    def read_character(character)
        self.current_states = rulebook.next_states(current_states, character)
    end

    def read_string(string)
        string.chars.each do |character|
            read_character(character)
        end
    end
end

class NFADesign < Struct.new(:start_state, :accept_states, :rulebook)
    def accepts?(string)
        to_nfa.tap { |nfa| nfa.read_string(string) }.accepting?
    end

    def to_nfa
        NFA.new(Set[start_state], accept_states, rulebook)
    end
end

rulebook = NFARulebook.new(
    [
        FARule.new(1, nil, 2),
        FARule.new(2, 'a', 3),
        FARule.new(3, 'a', 2),
        FARule.new(1, nil, 4),
        FARule.new(4, 'a', 5),
        FARule.new(5, 'a', 6),
        FARule.new(6, 'a', 4)
    ]
)

nfadesign = NFADesign.new(1, [2, 4], rulebook)

puts nfadesign.accepts?('a')
puts nfadesign.accepts?('aa')
puts nfadesign.accepts?('aaa')
puts nfadesign.accepts?('aaaa')
puts nfadesign.accepts?('aaaaa')

# Output

# false
# true
# true
# true
# false