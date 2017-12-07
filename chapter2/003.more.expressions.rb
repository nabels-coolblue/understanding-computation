# It isn’t difficult to extend this implementation to support other simple values and op- erations: subtraction and division; Boolean true and false; Boolean and, or, and not; comparison operations for numbers that return Booleans; and so on. For example, here are implementations of Booleans and the less-than operator.

# Goal: write implementations of Booleans and the less-than operator

class Machine < Struct.new(:expression)
    def step
        self.expression = expression.reduce
    end

    def run
        while expression.reducible?
            puts expression
            step
        end
        puts expression
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

class Boolean < Struct.new(:value)
    def reducible?
        false
    end

    def to_s
        value.to_s
    end

    def inspect 
        "«#{self}»"
    end
end

class LessThan < Struct.new(:left, :right)
    def reducible? 
        true
    end

    def reduce
        if self.left.reducible?
            LessThan.new(self.left.reduce, self.right)
        elsif self.right.reducible?
            LessThan.new(self.left, self.right.reduce)
        else
            Boolean.new(self.left.value < self.right.value)
        end
    end

    def to_s 
        "#{self.left} < #{self.right}"
    end

    def inspect 
        "«#{self}»"
    end
end

class GreaterThan < Struct.new(:left, :right)
    def reducible? 
        true
    end

    def reduce
        if left.reducible?
            GreaterThan.new(left.reduce, right)
        elsif self.right.reducible?
            GreaterThan.new(self.left, right.reduce)
        else
            Boolean.new(self.left.value > self.right.value)
        end
    end

    def to_s 
        "#{self.left} > #{self.right}"
    end

    def inspect 
        "«#{self}»"
    end
end

expression = 
LessThan.new(
    Multiply.new(
        Number.new(3), Number.new(0)
    ), 
    Add.new(
        Number.new(4), Number.new(6)
    )
)
Machine.new(expression).run

# Output:
# 3 * 0 < 4 + 6
# 0 < 4 + 6
# 0 < 10
# true