# What sets apart the pushdown automata from a Turing machine, is the more flexible way of storing state.
# As a mechanism to store state, we will be using a Tape, based on a one-dimensional array.

class Tape < Struct.new(:left, :middle, :right, :blank)
    def to_s
        "<Tape " + left.join + "(" + middle + ")" + right.join + "> >>"
    end

    def move_head_left
        _right = [middle].concat(right)
        _middle = left.reverse.take(1)
        _left = left.take(left.length - 1)

        Tape.new(_left, _middle.join, _right, blank)
    end

    def move_head_right
        _left = [middle].concat(left)
        
        if (right.length > 0)
            _middle = right.reverse.take(1)
            _right = right.take(right.length - 1)
        else
            _middle = [blank]
            _right = right
        end

        Tape.new(_left, _middle.join, _right, blank)
    end

    def write(char)
        Tape.new(left, char, right, blank)
    end
end

# The contract of a tape

puts tape = Tape.new(['1', '0', '1'], '1', [], '_')
puts "=> <Tape 101(1)> >>"

puts tape.middle 
puts '=> 1'

puts tape.move_head_left 
puts "=> #<Tape 10(1)1> >>"

puts tape.write('0')
puts "=> #<Tape 101(0)> >>"

puts tape.move_head_right 
puts "=> #<Tape 1011(_)> >>"

puts tape.move_head_right.write('0')
puts "=> #<Tape 1011(0)>"
puts tape.move_head_right.write('0')
puts "=> #<Tape 1011(0)>"
puts tape.move_head_right.write('0')
puts "=> #<Tape 1011(0)>"

# Documentation

# LENGTH / AT
# left.length
# 10
# left.at(9)
# 2
# left.at(10)
# nil

# SHIFT 
# args = [ "-m", "-q", "filename" ]
# args.shift     #=> "-m"
# args           #=> ["-q", "filename"]

# args = [ "-m", "-q", "filename" ]
# args.shift(2)  #=> ["-m", "-q"]
# args           #=> ["filename"]

# UNSHIFT 
# a = [ "b", "c", "d" ]
# a.unshift("a")   #=> ["a", "b", "c", "d"]
# a.unshift(1, 2)  #=> [ 1, 2, "a", "b", "c", "d"]

# TAKE
# [2, 3, 3, 3, 3, 3, 3, 3, 3, 2]
# left.take(0)
# []
# left.take(1)
# [2]
# left.take(2)
# [2, 3]

# DROP
# [2, 3, 3, 3, 3, 3, 3, 3, 3, 2]
# left.drop(1)
# [3, 3, 3, 3, 3, 3, 3, 3, 2]
