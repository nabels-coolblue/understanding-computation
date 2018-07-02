# Designing a rulebook would be easier if there was a way of calling a subroutine.
# If some part of the machine could store all the rules for, say, incrementing a number, then our
# rulebook could just say "now increment a numer, instead of having to manually string
# together the instructions to make that happen.

# Perhaps that extra flexibility would allow us to design machines with new capabilities.
# But this is another feature that is really just about convenience, not overall power.

require_relative "tm/dtm_rulebook"
require_relative "tm/dtm"
require_relative "tm/tape"
require_relative "tm/tm_rule"
require_relative "tm/tm_configuration"

# Convenience method for generating the rules required for incrementing a binary number.
def increment_rules(start_state, return_state)
  incrementing = start_state
  finishing = Object.new
  finished = return_state

  [
    TMRule.new(incrementing, "0", finishing, "1", :right),
    TMRule.new(incrementing, "1", incrementing, "0", :left),
    TMRule.new(incrementing, "_", finishing, "1", :right),
    TMRule.new(finishing, "0", finishing, "0", :right),
    TMRule.new(finishing, "1", finishing, "1", :right),
    TMRule.new(finishing, "_", finished, "_", :left),
  ]
end

added_zero, added_one, added_two, added_three = 0, 1, 2, 3

# Chaining the incrementing rule three times enables us to create a DTM that can add
# 3 to a binary number.
rulebook = DTMRulebook.new(
  increment_rules(added_zero, added_one) +
  increment_rules(added_one, added_two) +
  increment_rules(added_two, added_three)
)

puts rulebook.rules.length

tape = Tape.new(["1", "0", "1"], "1", [], "_")
puts tape
#<struct Tape left=["1", "0", "1"], middle="1", right=[], blank="_"> (decimal: 11)

dtm = DTM.new(TMConfiguration.new(added_zero, tape), [added_three], rulebook)
dtm.run
puts dtm.current_configuration.tape
#<struct Tape left=["1", "1", "1"], middle="0", right=["_"], blank="_"> (decimal: 14)
