# Write a while construct for use in big step operational semantics

# To confirm that this works properly, we can try evaluating the same «while» statement we used to check the small-step semantics:
# >> statement = While.new(
# LessThan.new(Variable.new(:x), Number.new(5)),
# Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3))) )
# => «while (x < 5) { x = x * 3 }»
# >> statement.evaluate({ x: Number.new(1) }) => {:x=>«9»}

class Multiply < Struct.new(:left, :right)
    def evaluate(environment)
        Number.new(self.left.evaluate(environment).value * self.right.evaluate(environment).value)
    end
end

class Add < Struct.new(:left, :right)
    def evaluate(environment)
        Number.new(self.left.evaluate(environment).value + self.right.evaluate(environment).value)
    end
end

class LessThan < Struct.new(:left, :right)
    def evaluate(environment)
        Boolean.new(left.evaluate(environment).value < right.evaluate(environment).value)
    end
end

class Boolean < Struct.new(:value)
    def evaluate(environment)
        self
    end
end

class Number < Struct.new(:value)
    def evaluate(environment)
        self
    end
end

class Variable < Struct.new(:name)
    def evaluate(environment)
        environment[name]
    end
end

class Assign < Struct.new(:name, :expression)
    def evaluate(environment)
        environment = environment.merge({ name => expression.evaluate(environment)})
    end
end

class Sequence < Struct.new(:first, :second)
    def evaluate(environment)
        environment = second.evaluate(first.evaluate(environment))
        puts environment
    end
end

class While < Struct.new(:condition, :body)
    def evaluate(environment)
        puts environment
        if (condition.evaluate(environment) == Boolean.new(true))
            environment = environment.merge(body.evaluate(environment))
            While.new(condition, body).evaluate(environment)
        end
    end
end

statement = While.new(
    LessThan.new(Variable.new(:x), Number.new(5)),
    Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3))) )
    # Resulting environment: {:x=>#<struct Number value=9>}

# Triggering a stackoverflow
While.new(
    LessThan.new(Variable.new(:x), Number.new(1000000)),
    Assign.new(:x, Add.new(Variable.new(:x), Number.new(1)))).evaluate({:x => Number.new(1)})
    # Breaks at: {:x=>#<struct Number value=9>}


