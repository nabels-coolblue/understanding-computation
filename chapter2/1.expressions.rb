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

while(expression.reducible?)
    puts expression
    expression = expression.reduce
end

puts expression

# sample output:
# 4 + 3 * 4 + 3 + 4 + 3
# 7 * 4 + 3 + 4 + 3
# 7 * 7 + 4 + 3
# 49 + 4 + 3
# 49 + 7
# 56
