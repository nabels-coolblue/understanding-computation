# For an easier way of inspecting whether strings are accepted or not, we will wrap our implementation into a DNPADesign class

require_relative 'data_structures/_all'
require_relative 'pda/_all'

class DPDADesign < Struct.new(:start_state, :start_character, :accept_states, :rulebook)
    def accepts?(string)
        to_dpda.tap { |dpda| dpda.read_string(string) }.accepting?
    end
    
    def to_dpda
        start_stack = Stack.new([start_character])
        start_configuration = PDAConfiguration.new(start_state, start_stack)
        DPDA.new(start_configuration, accept_states, rulebook)
    end
end

rulebook = DPDARulebook.new([
    PDARule.new(1, '(', 2, '$', ['b', '$']),
    PDARule.new(2, '(', 2, 'b', ['b', 'b']),
    PDARule.new(2, ')', 2, 'b', []),
    PDARule.new(2, nil, 1, '$', ['$'])
    ])

puts dpda_design = DPDADesign.new(1, '$', [1], rulebook)
# <struct DPDADesign …>
puts dpda_design.accepts?('(((((((((())))))))))')
# true
puts dpda_design.accepts?('()(())((()))(()(()))')
# true
puts dpda_design.accepts?('(()(()(()()(()()))()')
# false
