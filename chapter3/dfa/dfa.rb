class DFA < Struct.new(:current_state, :accept_states, :rulebook)
    def accepting?
        accept_states.include?(self.current_state)
    end

    def read_character(character)
        self.current_state = rulebook.next_state(self.current_state, character)
    end

    def read_characters(characters)
        characters.split("").each do |character|
            read_character(character)
        end

        self
    end
end