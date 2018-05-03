# This example serves to introduce the concept of a deterministic rulebook for PDAs

require_relative 'data_structures/_all'
require_relative 'pda/_all'

# The state, character and next_state need to match the current configuration of the machine in order for the rule to be applied
# - state           : the state the rule can act on (1, 2, 3, etc)
# - pop_character   : needs to match the topmost stack character ('(', ')', etc)
# - character       : needs to match the next input character

# - next_state      : if the rule applies, the machine should move to the specified state
# - push_characters : after the pop_character gets popped off the stack (when moving to the next_state), these characters are pushed

class DPDARulebook < Struct.new(:rules)
    def inspect
        puts "<struct DPDARulebook rules=#{rules}>"
    end

    def next_configuration(configuration, character)
        rule = rules.select { |rule| rule.applies_to?(configuration, character) }.at(0)
        configuration = rule.follow(configuration)
        configuration
    end
end

configuration = PDAConfiguration.new(1, Stack.new(['$']))

rulebook = DPDARulebook.new([
    PDARule.new(1, '(', 2, '$', ['b', '$']),
    PDARule.new(2, '(', 2, 'b', ['b', 'b']),
    PDARule.new(2, ')', 2, 'b', []),
    PDARule.new(2, nil, 1, '$', ['$'])
    ])

puts rulebook

puts "\n> Initial configuration:"
puts configuration

puts "\n> next character: '('"
configuration = rulebook.next_configuration(configuration, '(')
puts configuration

puts "\n> next character: '('"
configuration = rulebook.next_configuration(configuration, '(')
puts configuration

puts "\n> next character: ')'"
configuration = rulebook.next_configuration(configuration, ')')
puts configuration
