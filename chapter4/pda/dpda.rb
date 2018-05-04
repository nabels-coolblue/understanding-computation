class DPDA < Struct.new(:current_configuration, :accept_states, :rulebook)
    def current_configuration
        rulebook.follow_free_moves(super)
    end
    
    def stuck?
        current_configuration.stuck?
    end

    def accepting?
        ([current_configuration.state] & accept_states).any? && !stuck?
    end

    def read_string(string)
        string.chars.each do |character|
            read_character(character)
        end
    end    

    def read_character(character)
        self.current_configuration =
            rulebook.next_configuration(current_configuration, character)
    end
end