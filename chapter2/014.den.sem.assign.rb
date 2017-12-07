# assignment: write the following constructs: Assign / DoNothing / Sequence / If / While

# assignment: write the supporting constructs to allow for the following execution:

# >> statement = While.new(
#     LessThan.new(Variable.new(:x), Number.new(5)),
#     Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3))) )
#     => «while (x < 5) { x = x * 3 }»
#     >> statement.to_ruby
#     => "-> e { while (-> e { (-> e { e[:x] }).call(e) < (-> e { 5 }).call(e) }).call(e); ↵
#     e = (-> e { e.merge({ :x => (-> e { (-> e { e[:x] }).call(e) * (-> e { 3 }).call(e) ↵ }).call(e) }) }).call(e); end; e }"
#     >> proc = eval(statement.to_ruby)
#     => #<Proc (lambda)>
#     >> proc.call({ x: 1 }) => {:x=>9}

class Number < Struct.new(:value)
    def to_ruby
        "-> e { #{value.inspect} }"
    end
end

class Boolean < Struct.new(:value)
    def to_ruby
        "-> e { #{value.inspect} }"
    end
end

class Variable < Struct.new(:name)
    def to_ruby
        "-> e { e[#{name.inspect}] }"
    end
end

class Multiply < Struct.new(:left, :right)
    def to_ruby
        "-> e { (#{left.to_ruby}.call(e)) * (#{right.to_ruby}.call(e)) }"
    end
end

class LessThan < Struct.new(:left, :right)
    def to_ruby
        "-> e { #{left.to_ruby}.call(e) < #{right.to_ruby}.call(e) }"
    end
end

class DoNothing
    def to_ruby
        "-> e { e }"
    end
end

class While < Struct.new(:condition, :body)
    def to_ruby
        "-> e {" +
        " while (#{condition.to_ruby}).call(e); e = (#{body.to_ruby}).call(e); end;" + 
        " e" +
        " }"
    end 
end

class Assign < Struct.new(:name, :expression)
    def to_ruby
        "-> e { e.merge({ #{name.inspect} => (#{expression.to_ruby}).call(e) }) }" 
    end
end

statement = While.new(
    LessThan.new(Variable.new(:x), Number.new(5)),
    Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3))))

puts statement
proc = eval(statement.to_ruby)
puts proc
env = proc.call({x: 1})
puts env

# Output:

#<struct While condition=#<struct LessThan left=#<struct Variable name=:x>, right=#<struct Number value=5>>, body=#<struct Assign name=:x, expression=#<struct Multiply left=#<struct Variable name=:x>, right=#<struct Number value=3>>>>
#<Proc:0x007fd28d828c48@(eval):1 (lambda)>
#{:x=>9}
