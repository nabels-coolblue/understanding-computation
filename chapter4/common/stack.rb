# Create a stack class which acts as a data storage for pushdown automata.

class Stack < Struct.new(:chars)
    def top
        chars.at(0)
    end

    def pop
        chars.shift
        self
    end

    def push(char)
        chars.unshift(char)
        self
    end

end

# API behavior inspections

# >> stack = Stack.new(['a', 'b', 'c', 'd', 'e']) => #<Stack (a)bcde>
# >> stack.top
# => "a"
# >> stack.pop.pop.top
# => "c"
# >> stack.push('x').push('y').top
# => "y"
# >> stack.push('x').push('y').pop.top => "x"

stack = Stack.new(['a', 'b', 'c', 'd', 'e'])
puts stack
puts stack.top
puts stack.pop.pop.top
puts stack.push('x').push('y').top
puts stack.push('x').push('y').pop.top
