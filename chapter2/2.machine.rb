# By maintaining a piece of state - the current expression - and repeatedly calling #reducible? 
# and #reduce on it until we end up with a value, we're manually simulating the operation of 
# an abstract machine for evaluating expressions. (page 28)

# Goal: create an abstract machine for evaluating expressions
# 
# Name: Machine  
# Input: expression
# Methods: run
#   Output: the reduced expression

class Machine < Struct.new(:expression)
    def run
        while(self.expression.reducible?)
            self.expression = self.expression.reduce
            puts self.expression
        end
    end
end

class Number < Struct.new(:value)
    def reducible?
        false
    end

    def to_s
        "#{self.value}"
    end

    def inspect 
        "«#{self}»"
    end
end 

class Add < Struct.new(:left, :right)
    def reducible?
        true
    end

    def reduce
        if (self.left.reducible?)
            Add.new(self.left.reduce, self.right)
        elsif (self.right.reducible?)
            Add.new(self.left, self.right.reduce)
        else
            Number.new(self.left.value + self.right.value);
        end
    end 

    def to_s
        "#{self.left} + #{self.right}"
    end

    def inspect 
        "«#{self}»"
    end
end

class Multiply < Struct.new(:left, :right)
    def reducible?
        true
    end
    
    def reduce
        if (self.left.reducible?)
            Multiply.new(self.left.reduce, self.right)
        elsif (self.right.reducible?)
            Multiply.new(self.left, self.right.reduce)
        else
            Number.new(self.left.value * self.right.value);
        end
    end

    def to_s
        "#{self.left} * #{self.right}"
    end

    def inspect 
        "«#{self}»"
    end
end

expression = 
Add.new(
    Multiply.new(
        Add.new(Number.new(4), Number.new(3)),
        Add.new(Number.new(4), Number.new(3))
    ),
    Add.new(Number.new(4), Number.new(3))
)

Machine.new(expression).run