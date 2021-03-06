# Create a sample to verify the limits of a NFA
#
# Since the rulebook will always be finite, we will never be able to check something to an arbitrairy level of nesting

require_relative 'nfa/_all'

# Set up the rules of an NFA that can match brackets up until 3 levels deep
rulebook = NFARulebook.new(
    [
        FARule.new(1, '(', 2),
        FARule.new(2, '(', 3),
        FARule.new(3, '(', 4),
        FARule.new(4, ')', 3),
        FARule.new(3, ')', 2),
        FARule.new(2, ')', 1)
    ])

# Bootstrap the NFA
NFADesign < Struct.new(:start_state, :accept_states, :rulebook)
nfa_design = NFADesign.new(1, [1], rulebook)

# Experiments to show that 
puts nfa_design.accepts?('(()')        #  false / unmatched
puts nfa_design.accepts?('())')        #  false / unmatched
puts nfa_design.accepts?('(())')       #  true  / 2 levels deep
puts nfa_design.accepts?('(()(()()))') #  true  / 3 levels deep

# the following example shows the limitation of the NFA
# although the braces are balanced, it does not have enough states
# to consider this a correct example
puts nfa_design.accepts?('(((())))')   #  false / 4 levels deep         
