class Repeat < Struct.new(:pattern) 
    include Pattern

    def to_nfa_design
        
        # Add a new (accept) start state 
        # Add a free move to connect the new start state to the old start state 
        # Add a few free moves to connect the accept states to the old start state
        # Add all the accept states of the old NFA
        # Add all the rules of the old NFA

        pattern_nfa = pattern.to_nfa_design

        start_state_new = Object.new
        accept_states_new = [start_state_new]

        start_state_old = pattern_nfa.start_state
        accept_states_old = pattern_nfa.accept_states
        rulebook_old = pattern_nfa.rulebook
        
        rule_free_move_start = FARule.new(start_state_new, nil, start_state_old)
        rules_free_moves_accept = accept_states_old.map { |accept_old| FARule.new(accept_old, nil, start_state_old) }
        rules_old = rulebook_old.rules

        rules = [rule_free_move_start] + rules_free_moves_accept + rules_old

        NFADesign.new(start_state_new, accept_states_old + accept_states_new, NFARulebook.new(rules))
    end

    def to_s 
        pattern.bracket(precedence) + '*'
    end
    def precedence 
        2
    end 
end

