# Create a machine that can run the next statement, and produces the following output.

# >> Machine.new( If.new(
#     Variable.new(:x), Assign.new(:y, Number.new(1)), Assign.new(:y, Number.new(2))
#     ),
#     { x: Boolean.new(true) } ).run

# Output:

# if (x) { y = 1 } else { y = 2 }, {:x=>«true»} 
# if (true) { y = 1 } else { y = 2 }, {:x=>«true»} 
# y = 1, {:x=>«true»}
# do-nothing, {:x=>«true», :y=>«1»}

class Machine < Struct.new(:expression, :environment)
    def step
        self.expression, self.environment = expression.reduce(environment)
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
            [Assign.new(name, expression.reduce(environment)), environment]
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

Machine.new( If.new(
    Variable.new(:x), Assign.new(:y, Number.new(1)), Assign.new(:y, Number.new(2))
    ),
    { x: Boolean.new(true) } ).run

# Output:

# if (x) { y = 1 } else { y = 2 }, {:x=>«true»}
# if (true) { y = 1 } else { y = 2 }, {:x=>«true»}
# y = 1, {:x=>«true»}
# do-nothing, {:x=>«true», :y=>«1»}
