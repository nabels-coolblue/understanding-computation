# Implement a to_nfa_design method for regex/concatenate

require_relative 'nfa/_all'
require_relative 'regex/_all'

concatenate = Concatenate.new(Literal.new('a'), Literal.new('b'))
puts concatenate.matches?('ab') # true
puts concatenate.matches?('aa') # false
puts concatenate.matches?('aba') # false