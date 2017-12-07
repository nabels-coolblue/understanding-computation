# Goal:
# Add support for variables in SIMPLE

# Completed: the introduction of an environment completes our operational semantics of expressions. We’ve designed an abstract machine that begins with an initial expression and environment, and then uses the current expression and environment to produce a new expression in each small reduction step, leaving the environment unchanged.

class Machine < Struct.new(:expression, :environment)
    def step
        self.expression = expression.reduce(environment)
    end

    def run
        while expression.reducible?
            puts expression
            step
        end
        puts expression
    end
end

class Variable < Struct.new(:name)
    def reducible?
        true
    end

    def reduce(environment)
        environment[name]
    end

    def to_s
        "#{self.name}"
    end

    def inspect 
        "«#{self}»"
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

    def reduce(environment)
        if (self.left.reducible?)
            Add.new(self.left.reduce(environment), self.right)
        elsif (self.right.reducible?)
            Add.new(self.left, self.right.reduce(environment))
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

 Machine.new(
     Add.new(Variable.new(:x), Variable.new(:y)), 
     { x: Number.new(3), y: Number.new(4) }
     ).run

# Output: 
#  x + y
#  3 + y
#  3 + 4
#  7
