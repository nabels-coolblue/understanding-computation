require_relative 'data_structures/_all'
require_relative 'pda/_all'

class DPDA < Struct.new(:current_configuration, :accept_states, :rulebook)
    def current_configuration
        rulebook.follow_free_moves(super)
    end
    
    def accepting?
        ([current_configuration.state] & accept_states).any?
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

# Removing the common defition of DPDARulebook, since we're adding free moves
Object.send(:remove_const, :DPDARulebook) 
class DPDARulebook < Struct.new(:rules)
    def inspect
        puts "<struct DPDARulebook rules=#{rules}>"
    end

    def next_configuration(configuration, character)
        rule = rules.select { |rule| rule.applies_to?(configuration, character) }.at(0)
        configuration = rule.follow(configuration)
        configuration
    end

    def applies_to?(configuration, character)
        rules.select { |rule| rule.applies_to?(configuration, character) }.any?
    end

    def follow_free_moves(configuration)
        if applies_to?(configuration, nil)
            follow_free_moves(next_configuration(configuration, nil))
        else
            configuration
        end
    end
end

rulebook = DPDARulebook.new([
    PDARule.new(1, '(', 2, '$', ['b', '$']),
    PDARule.new(2, '(', 2, 'b', ['b', 'b']),
    PDARule.new(2, ')', 2, 'b', []),
    PDARule.new(2, nil, 1, '$', ['$'])
    ])

# let's use the rulebook to build a DPDA object that can keep track of the machine's current configuration as it reads characters from the input:
dpda = DPDA.new(PDAConfiguration.new(1, Stack.new(['$'])), [1], rulebook)
puts dpda                       #<struct DPDA …>
dpda.accepting?
puts dpda.accepting?            # true
dpda.read_string('(()'); 
puts dpda.accepting?            # false
puts dpda.current_configuration #=> #<struct PDAConfiguration state=2, stack=#<Stack (b)$>>

# the rulebook we're using contains a free move, so the simulation needs to support free moves before it'll work properly. 
puts configuration = PDAConfiguration.new(2, Stack.new(['$']))
#<struct PDAConfiguration state=2, stack=#<Stack ($)>>
free_moves = rulebook.follow_free_moves(configuration)
#<struct PDAConfiguration state=1, stack=#<Stack ($)>>
puts free_moves

# we will wrap the free moves functionality of the rulebook in order to expose it through the DPDA
dpda = DPDA.new(PDAConfiguration.new(1, Stack.new(['$'])), [1], rulebook)
dpda.read_string('(()('); puts dpda.accepting? 
# false
dpda.current_configuration
#<struct PDAConfiguration state=2, stack=#<Stack (b)b$>>
dpda.read_string('))()'); puts dpda.accepting?
#true
puts dpda.current_configuration
#<struct PDAConfiguration state=1, stack=#<Stack ($)>>
