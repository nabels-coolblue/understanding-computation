class TMRule < Struct.new(:state, :character, :next_state, :write_character, :direction)
    def to_s
        "<struct TMRule state=#{state}, character=#{character}, next_state=#{next_state}, write_character=#{write_character}, direction=#{direction}>"
    end

    def applies_to?(configuration)
        configuration.state == state && configuration.tape.middle == character
    end

    def follow(configuration)
        if (applies_to?(configuration))
            tape = direction == :right ? configuration.tape.write(write_character).move_head_right : configuration.tape.write(write_character).move_head_left
            TMConfiguration.new(next_state, tape)
        else
            configuration
        end
    end
end