class Empty 
    include Pattern
    def to_nfa_design
        start_state = Object.new
        accept_state = Object.new
        rule = FARule.new(start_state, nil, accept_state)
        rulebook = NFARulebook.new([rule])

        NFADesign.new(start_state, [accept_state], rulebook)
    end

    def to_s 
        ''
    end
    def precedence 
        3
    end 
end