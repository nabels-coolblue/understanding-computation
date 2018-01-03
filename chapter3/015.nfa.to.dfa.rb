# We will attempt to convert an NFA to a DFA. 

require_relative 'dfa/_all'
require_relative 'nfa/_all'
require_relative 'regex/_all'

# Set up the required rulebook and create an NFADesign
rulebook = NFARulebook.new([
FARule.new(1, 'a', 1), FARule.new(1, 'a', 2), FARule.new(1, nil, 2), FARule.new(2, 'b', 3),
FARule.new(3, 'b', 1), FARule.new(3, nil, 2)
])
nfa_design = NFADesign.new(1, [3], rulebook)

# Note: we've added the capability to the NFADesign class to start out with a state we can specify ourselves.
nfa_design.to_nfa.current_states
nfa_design.to_nfa(Set[2]).current_states
nfa_design.to_nfa(Set[3]).current_states
#<Set: {1, 2}>
#<Set: {2}>
#<Set: {3, 2}>

# Now we can create an NFA in any set of possible states, feed it a character, and see what states it might end up in, which is a crucial step for converting an NFA into a DFA. When our NFA is in state 2 or 3 and reads a b, what states can it be in afterward?
nfa = nfa_design.to_nfa(Set[2, 3])
nfa.read_character('b'); nfa.current_states
#<struct NFA current_states=#<Set: {2, 3}>, accept_states=[3], rulebook=...> 
#<Set: {3, 1, 2}>

simulation = NFASimulation.new(nfa_design) #<struct NFASimulation nfa_design=...>
puts simulation.next_state(Set[1, 2], 'a').inspect #<Set: {1, 2}>
puts simulation.next_state(Set[1, 2], 'b').inspect #<Set: {3, 2}>
puts simulation.next_state(Set[3, 2], 'b').inspect #<Set: {1, 3, 2}>
puts simulation.next_state(Set[1, 3, 2], 'b').inspect #<Set: {1, 3, 2}>
puts simulation.next_state(Set[1, 3, 2], 'a').inspect #<Set: {1, 2}>

# Let's add a method which can tell us which characters are involved in the NFA. Given this, we can find measures to inspect the NFA's states, by inputting these characters while setting the NFA to various states.
puts rulebook.alphabet # ["a", "b"]
puts simulation.rules_for(Set[1, 2]) 
# [
# #<FARule #<Set: {1, 2}> --a--> #<Set: {1, 2}>>,
# #<FARule #<Set: {1, 2}> --b--> #<Set: {3, 2}>> ]
puts simulation.rules_for(Set[3, 2])
# => [
# #<FARule #<Set: {3, 2}> --a--> #<Set: {}>>,
# #<FARule #<Set: {3, 2}> --b--> #<Set: {1, 3, 2}>> ]

# Note: Initially, we only know about a single state of the simulation: the set of possible states of our NFA when we put it into its start state. #discover_states_and_rules explores outward from this starting point, eventually finding all four states and eight rules of the simulation:

start_state = nfa_design.to_nfa.current_states 
puts start_state #<Set: {1, 2}>
puts simulation.discover_states_and_rules(Set[start_state])
# [
# #<Set: {
# #<Set: {1, 2}>, #<Set: {3, 2}>, #<Set: {}>, #<Set: {1, 3, 2}>
# }>,
# [
# #<FARule #<Set: {1, 2}> --a--> #<Set: {1, 2}>>, #<FARule #<Set: {1, 2}> --b--> #<Set: {3, 2}>>, #<FARule #<Set: {3, 2}> --a--> #<Set: {}>>, #<FARule #<Set: {3, 2}> --b--> #<Set: {1, 3, 2}>>, #<FARule #<Set: {}> --a--> #<Set: {}>>,
# #<FARule #<Set: {}> --b--> #<Set: {}>>,
# #<FARule #<Set: {1, 3, 2}> --a--> #<Set: {1, 2}>>, #<FARule #<Set: {1, 3, 2}> --b--> #<Set: {1, 3, 2}>>
# ] ]

# Now that we have all the pieces of the simulation DFA, we just need an NFASimulation #to_dfa_design method to wrap them up neatly as an instance of DFADesign. And that’s it. We can build an NFASimulation instance with any NFA and turn it into a DFA that accepts the same strings:

dfa_design = simulation.to_dfa_design 
puts dfa_design #<struct DFADesign ...>
puts dfa_design.accepts?('aaa') # false
puts dfa_design.accepts?('aab') # true
puts dfa_design.accepts?('bbbabb') # true
