class Concatenate < Struct.new(:first, :second) 
    include Pattern

    def to_nfa_design
        first_nfa = first.to_nfa_design
        second_nfa = second.to_nfa_design

        start_state = first_nfa.start_state
        accept_states = second_nfa.accept_states
        
        rules_free_moves = first_nfa.accept_states.map { |state| FARule.new(state, nil, second_nfa.start_state) }
        
        rule = FARule.new(first_nfa.accept_states[0], nil, second_nfa.start_state)
        rules = first_nfa.rulebook.rules + second_nfa.rulebook.rules + rules_free_moves

        NFADesign.new(start_state, accept_states, NFARulebook.new(rules))
    end


    def to_s
        [first, second].map { |pattern| pattern.bracket(precedence) }.join
    end
    def precedence 
        1
    end 
end
