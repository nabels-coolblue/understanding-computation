require 'set'

quantify = -> number {
    case number
    when 1
        '1'
    else
        'anders'
    end
}

puts quantify.call(1)
puts quantify.call(2)
puts quantify.call(2)

x = 1
while x < 1000
    puts x
    x = x * 2
end

puts x

o = Object.new
def o.add(x, y)
    x + y
end
def o.add_twice(x, y)
    add(add(x, y), add(x, y))
end

class Calculator 
    def divide(x, y)
        x/y 
    end
end

class MultiplyingCalculator < Calculator
    def multiply(x, y)
        x * y
    end
end

puts o.add(2, 3)
puts o.add_twice(2, 3)

aap = { 1 => "aap"}
noot = { 2 => "noot" }
aap = aap.merge(noot)
puts aap

characters = 'aab'

characters.split("").each do |c|
    puts c
end

Set[1, 2].flat_map{ |e| puts e }
puts [1, 2].select { |i| i }.map(&:inspect)
