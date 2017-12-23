# Implement a to_nfa_design method for regex/choose

# The ingredients for the combined machine are:

# - a new start state
# - all the accept states from both NFAs
# - all the rules from both NFAs
# - two extra free moves to connect the new start state to each of the NFA's old start states

require_relative 'nfa/_all'
require_relative 'regex/_all'

choose = Choose.new(Literal.new('a'), Literal.new('b'))
puts choose.matches?('a')  # true
puts choose.matches?('b')  # true
puts choose.matches?('ab') # false
puts choose.matches?('ba') # false

# Outputs:

# true
# true
# false
# false
