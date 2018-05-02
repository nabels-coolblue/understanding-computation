# Summary
# 
# A PDA (Pushdown Deterministic Automaton) is a type of deterministic automaton that makes use of a stack.
# The stack allows the automaton to have a, albeit of limited functionality, infinite amount of resources.
# We can use a PDA to implement a routine that checks whether the braces of a certain input string are
# balanced, up until an arbitrary depth, very much unlike DFAs and NFAs (001.nfa_nesting_limits.rb).
# 
# In this example however, we will be putting together a pda_configuration, which is the state to which
# the configuration applies, combined with a stack of characters which need to be pushed in case the 
# rule and configuration match.

require_relative 'data_structures/_all'
require_relative 'pda/_all'

rule = PDARule.new(1, '(', 2, '$', ['b', '$'])
puts rule
# <PDARule 
#         state=1
#         character="(">
#         next_state=2
#         pop_character="$"
#         push_characters=["b", "$"]>

configuration = PDAConfiguration.new(1, Stack.new(['$']))
puts configuration
# <PDAConfiguration 
# state=1
# stack="#<Stack ($)>">

puts rule.applies_to?(configuration, '(')
# true
