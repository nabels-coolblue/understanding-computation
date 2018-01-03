class DFADesign < Struct.new(:current_state, :accept_states, :rulebook)
    def accepts?(characters)
        to_dfa(characters).accepting?
    end

    def to_dfa(characters)
        DFA.new(current_state, accept_states, rulebook).read_characters(characters)
    end
end