class Number < Struct.new(:value)
    def reducible?
        false
    end

    def to_s
        "#<struct Number #{self.value} =>"
    end

    def reduce
        self
    end

    def inspect
        self
    end
end 

class Add < Struct.new(:left, :right)
    def reducible?
        true
    end

    def reduce
        if (self.left.reducible?)
            self.left = self.left.reduce
            puts to_s
        end
        
        if (self.right.reducible?)
            self.right = self.right.reduce
            puts to_s
        end

        Number.new(self.left.value + self.right.value);
    end

    def to_s
        "#<struct Add left=#{self.left}, right#{self.right}=>"
    end

    def inspect
        if (reducible?)
            puts to_s
            reduce;
        else
            Number.new(self.left.value + self.right.value);
        end
    end
end

class Multiply < Struct.new(:left, :right)
    def reducible?
        true
    end
    
    def reduce
        if (self.left.reducible?)
            self.left = self.left.reduce
            puts to_s
        end
           
        if (self.right.reducible?)
            self.right = self.right.reduce
            puts to_s
        end

        Number.new(self.left.value * self.right.value);
    end

    def to_s
        "#<struct Multiply left=#{self.left}, right#{self.right}=>"
    end

    def inspect
        if (reducible?)
           puts to_s
           reduce;
        else
            Number.new(self.left.value * self.right.value);
        end
    end
end

expression = Number.new(1)
puts "expression: #{expression}"
puts "evaluation:"
puts expression.inspect
puts

expression = Add.new(Number.new(1), Number.new(1))
puts "expression: #{expression}"
puts "evaluation:"
puts expression.inspect
puts

expression = Multiply.new(Number.new(1), Number.new(2))
puts "expression: #{expression}"
puts "evaluation:"
puts expression.inspect
puts

expression = Multiply.new(
    Add.new(Number.new(4), Number.new(3)),
    Number.new(3)
    )
puts "expression: #{expression}"
puts "evaluation:"
puts expression.inspect
puts