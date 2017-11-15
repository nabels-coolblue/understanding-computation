# We can now look at implementing a different kind of program construct: statements. The purpose of an expression is to be evaluated to produce another expression; a state- ment, on the other hand, is evaluated to make some change to the state of the abstract machine. Our machine’s only piece of state (aside from the current program) is the environment, so we’ll allow SIMPLE statements to produce a new environment that can replace the current one.

# Goal: make a machine that can evaluate an assignment, as follows:

# >> Machine.new(
#     Assign.new(:x, Add.new(Variable.new(:x), Number.new(1))), { x: Number.new(2) }
#     ).run
#     x = x + 1, {:x=>«2»} 
#     x = 2 + 1, {:x=>«2»} 
#     x = 3, {:x=>«2»} 
#     do-nothing, {:x=>«3»} 

class Machine < Struct.new(:expression, :environment)
    def step
        self.expression = expression.reduce(environment)
    end

    def run
        while expression.reducible?
            puts "#{expression}, #{environment}"
            step
        end

        puts "#{expression}, #{environment}"
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

class DoNothing
    def reducible?
        false
    end

    def to_s
        "do-nothing"
    end

    def inspect
        "«#{self}»"
    end
end

class Assign < Struct.new(:name, :expression)
    def reducible?
        true
    end

    def reduce(environment)
        if (expression.reducible?)
            Assign.new(name, expression.reduce(environment))
        else
            environment[name] = expression
            DoNothing.new
        end
    end 

    def to_s
        "#{name} = #{expression.to_s}"
    end

    def inspect
        "«#{self}»"
    end
end

Machine.new(
    Assign.new(:x, Add.new(Variable.new(:x), Number.new(1))), { x: Number.new(2) }
).run

# Output:
# x = x + 1, {:x=>«2»}
# x = 2 + 1, {:x=>«2»}
# x = 3, {:x=>«2»}
# do-nothing, {:x=>«3»}
