# Once a DFA object has been fed some input, it’s probably not in its start state anymore, so we can’t reliably reuse it to check a completely new sequence of inputs. That means we have to recreate it from scratch—using the same start state, accept states, and rule- book as before—every time we want to see whether it will accept a new string. We can avoid doing this manually by wrapping up its constructor’s arguments in an object that represents the design of a particular DFA and relying on that object to automatically build one-off instances of that DFA whenever we want to check for acceptance of a string.

# assignment: add functionality to support the following behaviour:

# >> dfa_design = DFADesign.new(1, [3], rulebook) => #<struct DFADesign ...>
# >> dfa_design.accepts?('a')
# => false
# >> dfa_design.accepts?('baa') => false
# >> dfa_design.accepts?('baba') => true

class DFADesign < Struct.new(:current_state, :accept_states, :rulebook)
    def accepts?(characters)
        to_dfa(characters).accepting?
    end

    def to_dfa(characters)
        DFA.new(current_state, accept_states, rulebook).read_characters(characters)
    end
end

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

class FARule < Struct.new(:current_state, :character, :next_state)
    def applies_to?(state, character)
        self.current_state == state and self.character == character
    end

    def follow
        next_state
    end

    def inspect
        "#<FARule #{state.inspect} --#{character}--> #{next_state.inspect}>"
    end
end

class DFARulebook < Struct.new(:allowed_states)
    def next_state(state, character)
        rule_for(state, character).follow
    end

    def rule_for(state, character)
        allowed_states.detect {|s| s.applies_to?(state, character)}
    end
end

rulebook = DFARulebook.new([
    FARule.new(1, 'a', 2), FARule.new(1, 'b', 1), FARule.new(2, 'a', 2), FARule.new(2, 'b', 3), FARule.new(3, 'a', 3), FARule.new(3, 'b', 3)
    ])

dfa_design = DFADesign.new(1, [3], rulebook)
puts dfa_design.accepts?('a')
puts dfa_design.accepts?('baa')
puts dfa_design.accepts?('baba')

# Output:

# false
# false
# true
