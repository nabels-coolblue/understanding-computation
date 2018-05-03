class DPDARulebook < Struct.new(:rules)
    def inspect
        puts "<struct DPDARulebook rules=#{rules}>"
    end

    def next_configuration(configuration, character)
        rule = rules.select { |rule| rule.applies_to?(configuration, character) }.at(0)
        configuration = rule.follow(configuration)
        configuration
    end
end
