# Write code that can be inspected as follows

#  Number.new(23).evaluate({})
#  Variable.new(:x).evaluate({ x: Number.new(23) })
#  LessThan.new(
#  Add.new(Variable.new(:x), Number.new(2)),
#  Variable.new(:y)
#  ).evaluate({ x: Number.new(2), y: Number.new(5) })

class Add < Struct.new(:left, :right)
    def evaluate(environment)
        Number.new(left.evaluate(environment).value + right.evaluate(environment).value)
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

Number.new(23).evaluate({})
# «23»
Variable.new(:x).evaluate({ x: Number.new(23) })
# «23»
LessThan.new(Add.new(Variable.new(:x), Number.new(2)),Variable.new(:y)).evaluate({ x: Number.new(2), y: Number.new(5) })
# «true»
