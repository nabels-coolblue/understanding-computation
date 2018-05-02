class PDAConfiguration < Struct.new(:state, :stack)
    def to_s
        "<PDAConfiguration 
        state=#{state}
        stack=\"#{stack}\">" 
    end
end