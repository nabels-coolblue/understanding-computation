class PDARule < Struct.new(:start_state, :character, :next_state, :pop_character, :push_characters)
    # A rule only applies when the machine’s state, topmost stack character, and next input
    # character all have the values it expects:
    def applies_to?(configuration, character)
        self.start_state == configuration.state &&
            self.pop_character == configuration.stack.top &&
            self.character == character
    end
    
    def to_s
        "<PDARule 
        state=#{start_state}
        character=\"#{character}\">
        next_state=#{next_state}
        pop_character=\"#{pop_character}\"
        push_characters=#{push_characters}>"
    end
end
