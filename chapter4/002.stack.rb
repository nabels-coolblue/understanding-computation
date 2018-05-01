# Create a class that implements the Stack data structure (last in, first out)

require_relative 'data_structures/_all'

puts stack = Stack.new(['a', 'b', 'c', 'd', 'e'])
# => <Stack (a)bcde>
puts stack.top
# => "a"
puts stack.pop.pop.top
# => "c"
puts stack.push('x').push('y').top
# => "y"
puts stack.push('x').push('y').pop.top
# => "x" 
