class Tape < Struct.new(:left, :middle, :right, :blank)
    def inspect
        "<Tape " + left.join + "(" + middle + ")" + right.join + ">"
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
