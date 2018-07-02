# Just for fun, here’s the Turing machine we saw earlier, for recognizing strings like 'aaabbbccc':

require_relative "tm/dtm_rulebook"
require_relative "tm/dtm"
require_relative "tm/tape"
require_relative "tm/tm_rule"
require_relative "tm/tm_configuration"

rulebook = DTMRulebook.new([
  # state 1: scan right looking for a
  TMRule.new(1, "X", 1, "X", :right), # skip X
  TMRule.new(1, "a", 2, "X", :right), # cross out a, go to state 2
  TMRule.new(1, "_", 6, "_", :left),  # find blank, go to state 6 (accept)

  # state 2: scan right looking for b
  TMRule.new(2, "a", 2, "a", :right), # skip a
  TMRule.new(2, "X", 2, "X", :right), # skip X
  TMRule.new(2, "b", 3, "X", :right), # cross out b, go to state 3

  # state 3: scan right looking for c
  TMRule.new(3, "b", 3, "b", :right), # skip b
  TMRule.new(3, "X", 3, "X", :right), # skip X
  TMRule.new(3, "c", 4, "X", :right), # cross out c, go to state 4

  # state 4: scan right looking for end of string
  TMRule.new(4, "c", 4, "c", :right), # skip c
  TMRule.new(4, "_", 5, "_", :left),  # find blank, go to state 5

  # state 5: scan left looking for beginning of string
  TMRule.new(5, "a", 5, "a", :left),  # skip a
  TMRule.new(5, "b", 5, "b", :left),  # skip b
  TMRule.new(5, "c", 5, "c", :left),  # skip c
  TMRule.new(5, "X", 5, "X", :left),  # skip X
  TMRule.new(5, "_", 1, "_", :right),  # find blank, go to state 1
])
tape = Tape.new([], "a", ["a", "a", "b", "b", "b", "c", "c", "c"], "_")
dtm = DTM.new(TMConfiguration.new(1, tape), [6], rulebook)
10.times { dtm.step }; dtm.current_configuration
25.times { dtm.step }; dtm.current_configuration
dtm.run; dtm.current_configuration

puts dtm.current_configuration.tape
puts dtm.current_configuration.state
# <struct TMConfiguration state=6, tape=#<Tape _XXXXXXXX(X)_>>

# This implementation was pretty easy to build, it’s not hard to simulate a Turing machine as long as we’ve got data structures to represent tapes and rulebooks. Of course, Alan Turing specifically intended them to be simple so they would be easy to build and to reason about, and we’ll see later (in “General-Purpose Machines” on page 154) that this ease of implementation is an important property.
