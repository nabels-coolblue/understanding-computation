# Just like with deterministic finite automata, we aim to creating a class which can create NFAs in order to check whether a given input leads to an accept state.

# Assignment: create code that runs and behaves as follows:

# >> nfa_design = NFADesign.new(1, [4], rulebook)
# => #<struct NFADesign start_state=1, accept_states=[4], rulebook=...> >> nfa_design.accepts?('bab')
# => true
# >> nfa_design.accepts?('bbbbb') => true
# >> nfa_design.accepts?('bbabb') => false

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

class NFA < Struct.new(:start_state, :accept_states, :rulebook)
    def accepts?(characters)
        # return if the current states intersect with the accept_states
        read_string(characters).intersect?(accept_states.to_set)
    end
    
    def read_string(characters)
        current_states = [start_state]
        characters.each_char { |c| current_states = next_states(current_states, c) }        
        current_states
    end

    def next_states(current_states, character)
        rulebook.next_states(current_states, character)
    end
end

class NFADesign < Struct.new(:start_state, :accept_states, :rulebook)
    def accepts?(characters)
        NFA.new(start_state, accept_states, rulebook).accepts?(characters)
    end
end

rulebook = NFARulebook.new([
    FARule.new(1, 'a', 1), FARule.new(1, 'b', 1), FARule.new(1, 'b', 2), FARule.new(2, 'a', 3), FARule.new(2, 'b', 3),
    FARule.new(3, 'a', 4), FARule.new(3, 'b', 4)
    ])

nfa_design = NFADesign.new(1, [4], rulebook)
puts nfa_design
puts nfa_design.accepts?('bbbbb')
puts nfa_design.accepts?('bbabb')

# Output:

# <struct NFADesign start_state=1, accept_states=[4], rulebook=#<struct NFARulebook rules=[#<FARule 1 --a--> 1>, #<FARule 1 --b--> 1>, #<FARule 1 --b--> 2>, #<FARule 2 --a--> 3>, #<FARule 2 --b--> 3>, #<FARule 3 --a--> 4>, #<FARule 3 --b--> 4>]>>
# true
# false
