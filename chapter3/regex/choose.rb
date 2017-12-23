# The ingredients for the combined machine are:

# - a new start state
# - all the accept states from both NFAs
# - all the rules from both NFAs
# - two extra free moves to connect the new start state to each of the NFA's old start states

class Choose < Struct.new(:first, :second) 
    include Pattern
    def to_nfa_design
        first_nfa = first.to_nfa_design
        second_nfa = second.to_nfa_design

        start_state = Object.new
        accept_states = first_nfa.accept_states + second_nfa.accept_states         

        first_nfa_free_move = FARule.new(start_state, nil, first_nfa.start_state)
        second_nfa_free_move = FARule.new(start_state, nil, second_nfa.start_state)

        rulebook = NFARulebook.new(
            first_nfa.rulebook.rules + 
            second_nfa.rulebook.rules + 
            [first_nfa_free_move] +
            [second_nfa_free_move])

        NFADesign.new(start_state, accept_states, rulebook)
    end

    def to_s
        [first, second].map { |pattern| pattern.bracket(precedence) }.join('|')
    end
    def precedence 
        0
    end 
end
