# Make a machine, that can run the statement provided and will produce the following output.

# Machine.new( While.new(
#     LessThan.new(Variable.new(:x), Number.new(5)),
#     Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3))) ),
#     { x: Number.new(1) } ).run

#     while (x < 5) { x = x * 3 }, {:x=>«1»}
#     if (x < 5) { x = x * 3; while (x < 5) { x = x * 3 } } else { do-nothing }, {:x=>«1»} if (1 < 5) { x = x * 3; while (x < 5) { x = x * 3 } } else { do-nothing }, {:x=>«1»} if (true) { x = x * 3; while (x < 5) { x = x * 3 } } else { do-nothing }, {:x=>«1»} x = x * 3; while (x < 5) { x = x * 3 }, {:x=>«1»}
#     x = 1 * 3; while (x < 5) { x = x * 3 }, {:x=>«1»}
#     x = 3; while (x < 5) { x = x * 3 }, {:x=>«1»}
#     do-nothing; while (x < 5) { x = x * 3 }, {:x=>«3»}
#     while (x < 5) { x = x * 3 }, {:x=>«3»}
#     if (x < 5) { x = x * 3; while (x < 5) { x = x * 3 } } else { do-nothing }, {:x=>«3»} if (3 < 5) { x = x * 3; while (x < 5) { x = x * 3 } } else { do-nothing }, {:x=>«3»} if (true) { x = x * 3; while (x < 5) { x = x * 3 } } else { do-nothing }, {:x=>«3»} x = x * 3; while (x < 5) { x = x * 3 }, {:x=>«3»}
#     x = 3 * 3; while (x < 5) { x = x * 3 }, {:x=>«3»}
#     x = 9; while (x < 5) { x = x * 3 }, {:x=>«3»}
#     do-nothing; while (x < 5) { x = x * 3 }, {:x=>«9»}
#     while (x < 5) { x = x * 3 }, {:x=>«9»}
#     if (x < 5) { x = x * 3; while (x < 5) { x = x * 3 } } else { do-nothing }, {:x=>«9»}
#     if (9 < 5) { x = x * 3; while (x < 5) { x = x * 3 } } else { do-nothing }, {:x=>«9»} if (false) { x = x * 3; while (x < 5) { x = x * 3 } } else { do-nothing }, {:x=>«9»} do-nothing, {:x=>«9»}
#     => nil    

class Machine < Struct.new(:sequence, :environment)
    def step
        self.sequence, self.environment = sequence.reduce(environment)
    end

    def run
        while sequence.reducible?
            puts "#{sequence}, #{environment}"
            step
        end

        puts "#{sequence}, #{environment}"
    end
end

class LessThan < Struct.new(:left, :right)
    def reducible? 
        true
    end

    def reduce(environment)
        if self.left.reducible?
            reduced_left, reduced_environment = self.left.reduce(environment)
            [LessThan.new(reduced_left, self.right), reduced_environment]
        elsif self.right.reducible?
            reduced_right, reduced_environment = self.right.reduce(environment)
            [LessThan.new(self.left, reduced_right), reduced_environment]
        else
            [Boolean.new(self.left.value < self.right.value), environment]
        end
    end

    def to_s 
        "#{self.left} < #{self.right}"
    end

    def inspect 
        "«#{self}»"
    end
end

class Variable < Struct.new(:name)
    def reducible?
        true
    end

    def reduce(environment)
        [environment[name], environment]
    end

    def to_s
        "#{self.name}"
    end

    def inspect 
        "«#{self}»"
    end
end


class Sequence < Struct.new(:first, :second)
    def reducible?
        true
    end

    def reduce(environment)
        case first
        when DoNothing.new
            [second, environment]
        else 
            reduced_first, reduced_environment = first.reduce(environment)
            [Sequence.new(reduced_first, second), reduced_environment]
        end
    end

    def to_s
        "#{self.first}; #{self.second}"
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

class DoNothing
    def reducible?
        false
    end

    def ==(other)
        other.instance_of?(DoNothing)
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
            reduced_expression, reduced_environment = expression.reduce(environment)
            [Assign.new(name, reduced_expression), reduced_environment]
        else
            [DoNothing.new, environment.merge({ name => expression})]
        end
    end 

    def to_s
        "#{name} = #{expression.to_s}"
    end

    def inspect
        "«#{self}»"
    end
end

class Multiply < Struct.new(:left, :right)
    def reducible?
        true
    end
    
    def reduce(environment)
        if (self.left.reducible?)
            reduced_left, reduced_environment = self.left.reduce(environment)
            [Multiply.new(reduced_left, self.right), reduced_environment]
        elsif (self.right.reducible?)
            reduced_right, reduced_environment = self.right.reduce(environment)
            [Multiply.new(self.left, reduced_right), reduced_environment]
        else
            [Number.new(self.left.value * self.right.value), environment]
        end
    end

    def to_s
        "#{self.left} * #{self.right}"
    end

    def inspect 
        "«#{self}»"
    end
end

class While < Struct.new(:condition, :body)
    def reducible?
        true
    end

    def reduce(environment)
        [If.new(condition, Sequence.new(body, self), DoNothing.new), environment]
    end
    
    def to_s
        "while (#{condition}) { #{body} }"
    end

    def inspect
        "«#{self}»"
    end
end

class If < Struct.new(:condition, :consequence, :alternative)
    def reducible? 
        true
    end

    def reduce (environment)
        if self.condition.reducible?
            [If.new(self.condition.reduce(environment)[0], self.consequence, self.alternative), environment]
        else
            case (condition)
            when Boolean.new(true)
                [consequence, environment]
            when Boolean.new(false)
                [alternative, environment]
            end
        end
    end

    def to_s 
        "if (#{condition}) { #{consequence} } else { #{alternative} }"
    end

    def inspect 
        "«#{self}»"
    end
end

Machine.new( While.new(
    LessThan.new(Variable.new(:x), Number.new(5)),
    Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3))) ),
    { x: Number.new(1) } ).run
