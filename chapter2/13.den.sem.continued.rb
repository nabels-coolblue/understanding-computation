# Create the additions to SIMPLE that yield the following result:

# >> Add.new(Variable.new(:x), Number.new(1)).to_ruby
# => "-> e { (-> e { e[:x] }).call(e) + (-> e { 1 }).call(e) }"
# >> LessThan.new(Add.new(Variable.new(:x), Number.new(1)), Number.new(3)).to_ruby 
# => "-> e { (-> e { (-> e { e[:x] }).call(e) + (-> e { 1 }).call(e) }).call(e) < ↵ (-> e { 3 }).call(e) }"

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

class Add < Struct.new(:left, :right)
    def to_ruby
        "-> e { (#{left.to_ruby}.call(e)) + (#{right.to_ruby}.call(e)) }"
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

# puts Add.new(Number.new(1), Number.new(2)).to_ruby
# proc = eval(Add.new(Number.new(1), Number.new(2)).to_ruby)
# puts proc.call({})

add = Add.new(Variable.new(:x), Number.new(1)).to_ruby
puts add
puts eval(add).call({ x: 5 })

lessThan = LessThan.new(Add.new(Variable.new(:x), Number.new(1)), Number.new(3)).to_ruby 
puts lessThan
puts eval(lessThan).call({ x: 5 })
