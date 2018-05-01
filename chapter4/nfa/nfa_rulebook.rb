require 'set'

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

