# It’s easy enough to implement #to_nfa_design methods for Empty and Literal to generate these NFAs. 

# >> nfa_design = Empty.new.to_nfa_design => #<struct NFADesign ...>
# >> nfa_design.accepts?('')
# => true
# >> nfa_design.accepts?('a')
# => false
# >> nfa_design = Literal.new('a').to_nfa_design => #<struct NFADesign ...>
# >> nfa_design.accepts?('')
# => false
# >> nfa_design.accepts?('a')
# => true
# >> nfa_design.accepts?('b')
# => false

require_relative 'nfa/_all'
require_relative 'regex/_all'

nfa_design = Empty.new.to_nfa_design
puts nfa_design
puts nfa_design.accepts?('')
puts nfa_design.accepts?('a')

nfa_design = Literal.new('a').to_nfa_design 
puts nfa_design.accepts?('')
puts nfa_design.accepts?('a')
puts nfa_design.accepts?('b')

# Output:

# <struct NFADesign start_state=1, accept_states=[2], rulebook=#<struct NFARulebook rules=[#<FARule 1 ----> 2>]>>
# true
# false
# false
# true
# false

# With the addition of a matches? method the patterns can get a better interface.

puts Empty.new.matches?('')
puts Empty.new.matches?('a')

puts Literal.new('a').matches?('a')
puts Literal.new('a').matches?('b')

# Output:

# true
# false
# true
# false
