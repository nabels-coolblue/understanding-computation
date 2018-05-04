# This example serves to introduce the concept of a deterministic rulebook for PDAs

require_relative 'data_structures/_all'
require_relative 'pda/_all'

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
