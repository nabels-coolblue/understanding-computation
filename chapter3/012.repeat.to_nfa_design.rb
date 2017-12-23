# Implement a to_nfa_design method for regex/repeat

# Add a new (accept) start state 
# Add a free move to connect the new start state to the old start state 
# Add a few free moves to connect the accept states to the old start state
# Add all the accept states of the old NFA
# Add all the rules of the old NFA

require_relative 'nfa/_all'
require_relative 'regex/_all'

puts Repeat.new(Literal.new('a')).matches?('') # true
puts Repeat.new(Literal.new('a')).matches?('a') # true
puts Repeat.new(Literal.new('a')).matches?('aa') # true
puts Repeat.new(Literal.new('a')).matches?('b') # false
puts Repeat.new(Literal.new('a')).matches?('ab') # false

# Output:
# true
# true
# true
# false
# false
