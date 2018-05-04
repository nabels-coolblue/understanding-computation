# Objective: prevent the DNPA from blowing up when getting into a stuck state

require_relative 'data_structures/_all'
require_relative 'pda/_all'

rulebook = DPDARulebook.new([
    PDARule.new(1, '(', 2, '$', ['b', '$']),
    PDARule.new(2, '(', 2, 'b', ['b', 'b']),
    PDARule.new(2, ')', 2, 'b', []),
    PDARule.new(2, nil, 1, '$', ['$'])
    ])

dpda_design = DPDADesign.new(1, '$', [1], rulebook)

# Our simulations work when the DPDA is left in a valid state. However, when it gets stuck, it blows up. Uncomment the following line for an example.

# dpda_design.accepts?('())')
# Uncaught exception: undefined method `follow' for nil:NilClass

# Now, let's make changes that will make the DPDA go into a 'stuck' state, instead of blowing up

Object.send(:remove_const, :DPDARulebook) 
class DPDARulebook < Struct.new(:rules)
    def inspect
        puts "<struct DPDARulebook rules=#{rules}>"
    end

    def next_configuration(configuration, character)
        rule = rules.select { |rule| rule.applies_to?(configuration, character) }.at(0)
        if (rule == nil)
            configuration.set_stuck()
            configuration
        else
            configuration = rule.follow(configuration)
            configuration
        end
    end

    def applies_to?(configuration, character)
        rules.select { |rule| rule.applies_to?(configuration, character) }.any?
    end

    def follow_free_moves(configuration)
        if applies_to?(configuration, nil)
            follow_free_moves(next_configuration(configuration, nil))
        else
            configuration
        end
    end
end

Object.send(:remove_const, :DPDA) 
class DPDA < Struct.new(:current_configuration, :accept_states, :rulebook)
    def current_configuration
        rulebook.follow_free_moves(super)
    end
    
    def stuck?
        current_configuration.stuck?
    end

    def accepting?
        ([current_configuration.state] & accept_states).any? && !stuck?
    end

    def read_string(string)
        string.chars.each do |character|
            read_character(character)
        end
    end    

    def read_character(character)
        self.current_configuration =
            rulebook.next_configuration(current_configuration, character)
    end
end

Object.send(:remove_const, :PDAConfiguration) 
class PDAConfiguration < Struct.new(:state, :stack)
    STUCK_STATE = Object.new

    def to_s
        "<PDAConfiguration 
        state=#{state}
        stack=\"#{stack}\">" 
    end

    def stuck
        PDAConfiguration.new(STUCK_STATE, stack)
    end

    def is_stuck?
        @STUCK_STATE
    end
end

# Previously, this would blow up, however, now it recognizes this as a non-accepted string
puts dpda_design.accepts?('())') 
# false
