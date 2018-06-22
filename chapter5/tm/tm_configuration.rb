class TMConfiguration < Struct.new(:state, :tape)
    def inspect
        puts "<TMConfiguration state=#{state} tape=#{tape}>"
    end
end
