# Given a regular expression and a string, how do we write a program to decide whether the string matches that expression? Most programming languages, Ruby included, al- ready have regular expression support built in, but how does that support work? How would we implement regular expressions in Ruby if the language didn’t already have them?

# It turns out that finite automata are perfectly suited to this job. As we’ll see, it’s possible to convert any regular expression into an equivalent NFA—every string matched by the regular expression is accepted by the NFA, and vice versa—and then match a string by feeding it to a simulation of that NFA to see whether it gets accepted. In the language of Chapter 2, we can think of this as providing a sort of denotational semantics for regular expressions: we may not know how to execute a regular expression directly, but we can show how to denote it as an NFA, and because we have an operational semantics for NFAs (“change state by reading characters and following rules”), we can execute the denotation to achieve the same result.

# Assignment: implement the classes required to run the following code:

# >> pattern = Repeat.new(
#     Choose.new(
#     Concatenate.new(Literal.new('a'), Literal.new('b')),
#     Literal.new('a') )
#     )
#     => /(ab|a)*/
    
module Pattern
    def bracket(outer_precedence)
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

class Empty 
    include Pattern
    def to_s 
        ''
    end
    def precedence 
        3
    end 
end

class Literal < Struct.new(:character) 
    include Pattern
    def to_s 
        character
    end
    def precedence 
        3
    end 
end

class Repeat < Struct.new(:pattern) 
    include Pattern
    def to_s 
        pattern.bracket(precedence) + '*'
    end
    def precedence 
        2
    end 
end

class Concatenate < Struct.new(:first, :second) 
    include Pattern
    def to_s
        [first, second].map { |pattern| pattern.bracket(precedence) }.join
    end
    def precedence 
        1
    end 
end

class Choose < Struct.new(:first, :second) 
    include Pattern
    def to_s
        [first, second].map { |pattern| pattern.bracket(precedence) }.join('|')
    end
    def precedence 
        0
    end 
end

pattern = Repeat.new(
    Choose.new(
    Concatenate.new(Literal.new('a'), Literal.new('b')),
    Literal.new('a') )
)

puts pattern

# Output: 
# (ab|a)*