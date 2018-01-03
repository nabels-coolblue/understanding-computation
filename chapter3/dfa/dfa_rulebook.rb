class DFARulebook < Struct.new(:allowed_states)
    def next_state(state, character)
        rule_for(state, character).follow
    end

    def rule_for(state, character)
        allowed_states.detect {|s| s.applies_to?(state, character)}
    end
end