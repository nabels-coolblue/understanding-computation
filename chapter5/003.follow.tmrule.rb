# When a rule applies to a configuration (tape and state), we would like to update the configuration by writing a new character, moving the tape head and changing the machine's state in accordance with the rule.

require_relative 'tm/tape'
require_relative 'tm/tm_configuration'

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

rule = TMRule.new(1, '0', 2, '1', :right)
puts rule.follow(TMConfiguration.new(1, Tape.new([], '0', [], '_')))
#<struct TMConfiguration state=2, tape=#<Tape 1(_)>>
