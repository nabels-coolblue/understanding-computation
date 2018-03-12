# Create a stack class which acts as a data storage for pushdown automata.

class Stack < Struct.new(:chars)
    def top
        chars.at(0)
    end

    def pop
        Stack.new(chars.drop(1))
    end

    def push(char)
        Stack.new([char] + chars)        
    end

    def inspect
        "#<Stack (#{top})#{chars.drop(1).join}>"
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
puts stack.inspect
puts stack.top
puts stack.pop.pop.top
puts stack.push('x').push('y').top
puts stack.push('x').push('y').pop.top
