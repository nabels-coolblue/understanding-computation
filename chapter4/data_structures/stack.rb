class Stack < Struct.new(:characters)
    def top
        characters.first
    end

    def to_s
        "#<Stack (#{top})#{characters.drop(1).join}>"
    end
    
    def pop
        characters.shift
        Stack.new(characters)
    end

    def push(char)
        characters.unshift(char)
        Stack.new(characters)
    end
end