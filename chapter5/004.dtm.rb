# In order to save ourselves some headaches, let's create some classes per our convenience.
# We will create DTMRulebook to bundle the rules into a rulebook.
# We will create DTM to have a machine which can autonomously step until it has reached an accept state.

require_relative "tm/tm_configuration"
require_relative "tm/tm_rule"
require_relative "tm/tape"

class DTMRulebook < Struct.new(:rules, :direction)
  def next_configuration(configuration)
    rule_for?(configuration).follow(configuration)
  end

  def rule_for?(configuration)
    rules.detect { |rule| rule.applies_to?(configuration) }
  end
end

rulebook = DTMRulebook.new(
  [
    TMRule.new(1, "0", 2, "1", :right),
    TMRule.new(1, "1", 1, "0", :left),
    TMRule.new(1, "_", 2, "1", :right),
    TMRule.new(2, "0", 2, "0", :right),
    TMRule.new(2, "1", 2, "1", :right),
    TMRule.new(2, "_", 3, "_", :left),
  ]
)

# Inspect the behaviour of our rulebook
tape = Tape.new(["1", "0", "1"], "1", [], "_")
#<struct DTMRulebook rules=[...]>
puts configuration = TMConfiguration.new(1, tape)
#<struct TMConfiguration state=1, tape=#<Tape 101(1)>>
puts configuration = rulebook.next_configuration(configuration)
#<struct TMConfiguration state=1, tape=#<Tape 10(1)0>>
puts configuration = rulebook.next_configuration(configuration)
#<struct TMConfiguration state=1, tape=#<Tape 1(0)00>>
puts configuration = rulebook.next_configuration(configuration)
#<struct TMConfiguration state=2, tape=#<Tape 11(0)0>>

class DTM < Struct.new(:configuration, :accept_states, :rulebook)
  def current_configuration
    configuration
  end

  def accepting?
    accept_states.include?(configuration.state)
  end

  def step
    self.configuration = rulebook.next_configuration(configuration)
  end

  def run
    while !accepting? && !stuck?
      step
    end
  end

  def stuck?
    !accepting? && !rulebook.rule_for?(configuration)
  end
end

# Inspect the behaviour of our machine, stepping through a bunch of rules that should lead to an accept_state
dtm = DTM.new(TMConfiguration.new(1, tape), [3], rulebook)
puts
#<struct DTM ...>
puts dtm.current_configuration
#<struct TMConfiguration state=1, tape=#<Tape 101(1)>>
puts dtm.accepting?
#false
dtm.step
puts dtm.current_configuration
#<struct TMConfiguration state=1, tape=#<Tape 10(1)0>>
puts dtm.accepting?
#false
puts dtm.run.inspect
#nil
puts dtm.current_configuration
#<struct TMConfiguration state=3, tape=#<Tape 110(0)_>>
puts dtm.accepting?
#true

# Inspect the behaviour of our machine where she is destined to fail
tape = Tape.new(["1", "2", "1"], "1", [], "_")
dtm = DTM.new(TMConfiguration.new(1, tape), [3], rulebook)
dtm.run
puts dtm.accepting?
#false
