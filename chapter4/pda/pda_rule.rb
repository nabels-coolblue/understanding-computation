# Rules for pushdown automata have the following properties.

# The state, character and next_state need to match the current configuration of the machine in order for the rule to be applied
# - state           : the state the rule can act on (1, 2, 3, etc)
# - pop_character   : needs to match the topmost stack character ('(', ')', etc)
# - character       : needs to match the next input character

# - next_state      : if the rule applies, the machine should move to the specified state
# - push_characters : after the pop_character gets popped off the stack (when moving to the next_state), these characters are pushed

class PDARule < Struct.new(:start_state, :character, :next_state, :pop_character, :push_characters)
    # A rule only applies when the machine’s state, topmost stack character, and next input
    # character all have the values it expects:
    def applies_to?(configuration, character)
        self.start_state == configuration.state &&
            self.pop_character == configuration.stack.top &&
            self.character == character
    end
    
    def follow(configuration)
        PDAConfiguration.new(next_state, next_stack(configuration))
    end

    def next_stack(configuration)
        popped_stack = configuration.stack.pop

        push_characters.reverse.
            inject(popped_stack) { |stack, character| stack.push(character) }
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
