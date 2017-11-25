# Make a machine, that can run the statement provided and will produce the following output.

# >> Machine.new( Sequence.new(
#     Assign.new(:x, Add.new(Number.new(1), Number.new(1))),
#     Assign.new(:y, Add.new(Variable.new(:x), Number.new(3))) ),
#     {} ).run
#     x = 1 + 1; y = x + 3, {}
#     x = 2; y = x + 3, {} do-nothing; y = x + 3, {:x=>«2»} y = x + 3, {:x=>«2»}
#     y = 2 + 3, {:x=>«2»}
#     y = 5, {:x=>«2»}
#     do-nothing, {:x=>«2», :y=>«5»} => nil

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

class Add < Struct.new(:left, :right)
    def reducible?
        true
    end

    def reduce(environment)
        if (self.left.reducible?)
            reduced_left, reduced_environment = self.left.reduce(environment)
            [Add.new(reduced_left, self.right), reduced_environment]
        elsif (self.right.reducible?)
            reduced_right, reduced_environment = self.right.reduce(environment)
            [Add.new(self.left, reduced_right), reduced_environment]
        else
            [Number.new(self.left.value + self.right.value), environment]
        end
    end 

    def to_s
        "#{self.left} + #{self.right}"
    end

    def inspect 
        "«#{self}»"
    end
end

Machine.new( Sequence.new(
    Assign.new(:x, Add.new(Number.new(1), Number.new(1))),
    Assign.new(:y, Add.new(Variable.new(:x), Number.new(3))) ),
    {} ).run

# x = 1 + 1; y = x + 3, {}
# x = 2; y = x + 3, {}
# do-nothing; y = x + 3, {:x=>«2»}
# y = x + 3, {:x=>«2»}
# y = 2 + 3, {:x=>«2»}
# y = 5, {:x=>«2»}
# do-nothing, {:x=>«2», :y=>«5»}