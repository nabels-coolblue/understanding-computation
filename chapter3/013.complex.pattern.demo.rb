require_relative 'nfa/_all'
require_relative 'regex/_all'

# Now that we have #to_nfa_design implementations for each class of regular expression syntax, we can build up complex patterns and use them to match strings:

pattern = Repeat.new(
Concatenate.new( Literal.new('a'),
Choose.new(Empty.new, Literal.new('b')) )
)

puts pattern # => /(a(|b))*/

puts pattern.matches?('') # true
puts pattern.matches?('a') # true
puts pattern.matches?('ab') # true
puts pattern.matches?('aba') # true
puts pattern.matches?('abab') # true
puts pattern.matches?('abaab') # true
puts pattern.matches?('abba') # false

# Output:

# (a(|b))*
# true
# true
# true
# true
# true
# true
# false
