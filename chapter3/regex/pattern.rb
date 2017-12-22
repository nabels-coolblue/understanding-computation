module Pattern
    def matches?(string)
        to_nfa_design.accepts?(string)
    end
    
    def bracket(outer_precedence)

        puts "precedence - outer_precedence - to_s : [#{precedence}] - [#{outer_precedence}] - [#{to_s}] - [#{self.class}]" 

        if precedence < outer_precedence 
            '('+to_s+')'
        else
            to_s
        end 
    end
    def inspect 
        "/#{self}/"
    end 
end
