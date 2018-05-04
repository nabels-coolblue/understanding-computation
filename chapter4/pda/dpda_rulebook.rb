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
