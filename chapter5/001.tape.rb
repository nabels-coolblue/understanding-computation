# What sets apart the pushdown automata from a Turing machine, is the more flexible way of storing state.
# As a mechanism to store state, we will be using a Tape, based on a one-dimensional array.

class Tape < Struct.new(:left, :middle, :right, :blank)
    def to_s
        "    <Tape " + left.join + "(" + middle + ")" + right.join + ">"
    end

    def move_head_left
        _left = left[0..-2]
        _middle = left.last
        _right = [middle] + right

        Tape.new(_left, _middle, _right, blank)
    end

    def move_head_right
        _left = left + [middle]
        _middle = right.first || blank
        _right = right.drop(1)

        Tape.new(_left, _middle, _right, blank)
    end

    def write(char)
        Tape.new(left, char, right, blank)
    end
end

puts "We use the contract of the tape to run a few behavioural tests"
puts "Every line of output is followed by its desired output (starting with [V])"
puts 

puts tape = Tape.new(['1', '0', '1'], '1', [], '_')
puts "[V] <Tape 101(1)>"
puts

puts tape.write('0')
puts "[V] <Tape 101(0)>"
puts

puts tape.move_head_left 
puts "[V] <Tape 10(1)1>"
puts

puts tape.move_head_right 
puts "[V] <Tape 1011(_)>"
puts

puts tape.move_head_right.write('0')
puts "[V] <Tape 1011(0)>"

# Output:

#     <Tape 101(1)>
# [V] <Tape 101(1)>
#     <Tape 101(0)>
# [V] <Tape 101(0)>
#     <Tape 10(1)1>
# [V] <Tape 10(1)1>
#     <Tape 1011(_)>
# [V] <Tape 1011(_)>
#     <Tape 1011(0)>
# [V] <Tape 1011(0)>