# Summary
# 
# A PDA (Pushdown Automaton) is a type of automaton that makes use of a stack.
# The stack allows the automaton to have a, albeit of limited functionality, infinite amount of resources.
# We can use a PDA to implement a routine that checks whether the braces of a certain input string are
# balanced, up until an arbitrary depth, very much unlike DFAs and NFAs (001.nfa_nesting_limits.rb).
# 
# In this example however, we will be putting together a pda_configuration, which is the state to which
# the configuration applies, combined with the current stack (of characters).
#
# Understanding computation on the pda_configuration:
# But there are two important things to know about a pushdown automaton at each step of
# its computation: what its current state is, and what the current contents of its stack are.
# If we use the word configuration to refer to this combination of a state and a stack, we
# can talk about a pushdown automaton moving from one configuration to another as
# it reads input characters, which is easier than always having to refer to the state and
# stack separately.

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
