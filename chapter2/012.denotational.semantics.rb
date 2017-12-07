# Denotational Semantics

# So far, we’ve looked at the meaning of programming languages from an operational perspective, explaining what a program means by showing what will happen when it’s executed. Another approach, denotational semantics, is concerned instead with translating programs from their native language into some other representation.

# >> proc = eval(Number.new(5).to_ruby) => #<Proc (lambda)>
# >> proc.call({})
# => 5
# >> proc = eval(Boolean.new(false).to_ruby) => #<Proc (lambda)>
# >> proc.call({})
# => false

# Procs
# A proc is an unevaluated chunk of Ruby code that can be passed around and evaluated on demand; other languages call this an “anonymous function” or “lambda.”

# Sample Proc:

add = -> x, y { x + y }
puts "1 + 2 = #{add.call(1, 2)}"

# Exercise:

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

proc = eval(Number.new(5).to_ruby)
puts proc.call({})

proc = eval(Boolean.new(false).to_ruby)
puts proc.call({})

proc = eval(Variable.new(:x).to_ruby)
puts proc.call({ x: 42 })

# Output: 

# 5
# false
