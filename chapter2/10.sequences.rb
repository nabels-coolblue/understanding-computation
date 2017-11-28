# >> statement = Sequence.new(
#     Assign.new(:x, Add.new(Number.new(1), Number.new(1))),
#     Assign.new(:y, Add.new(Variable.new(:x), Number.new(3))) )
#     => «x = 1 + 1; y = x + 3»
#     >> statement.evaluate({}) => {:x=>«2», :y=>«5»}

class Add < Struct.new(:left, :right)
    def evaluate(environment)
        Number.new(self.left.evaluate(environment).value + self.right.evaluate(environment).value)
    end
    def to_s
        "«#{left} + #{right}»"
    end

    def inspect
        "#{self}"
    end
end

class LessThan < Struct.new(:left, :right)
    def evaluate(environment)
        Boolean.new(left.evaluate(environment).value < right.evaluate(environment).value)
    end

    def to_s
        "«if (#{left} < #{right}) »"
    end

    def inspect
        "#{self}"
    end
end

class Boolean < Struct.new(:value)
    def evaluate(environment)
        self
    end

    def to_s
        "«#{value}»"
    end

    def inspect
        "#{self}"
    end
end

class Number < Struct.new(:value)
    def evaluate(environment)
        self
    end

    def to_s
        "«#{value}»"
    end

    def inspect
        "#{self}"
    end
end

class Variable < Struct.new(:name)
    def evaluate(environment)
        environment[name]
    end

    def to_s
        "«#{name}»"
    end

    def inspect
        "#{self}"
    end
end

class Assign < Struct.new(:name, :expression)
    def evaluate(environment)
        environment = environment.merge({ name => expression.evaluate(environment)})
    end
    
    def to_s
        "«#{name}»"
    end

    def inspect
        "#{self}"
    end    
end

class Sequence < Struct.new(:first, :second)
    def evaluate(environment)
        environment = second.evaluate(first.evaluate(environment))
        puts environment
    end

    def to_s
        "«#{first}; #{second}»"
    end

    def inspect
        "#{self}"
    end
end

statement = Sequence.new(
    Assign.new(:x, Add.new(Number.new(1), Number.new(1))),
    Assign.new(:y, Add.new(Variable.new(:x), Number.new(3))) )
    statement.evaluate({}) 

    #{:x=>«2», :y=>«5»}