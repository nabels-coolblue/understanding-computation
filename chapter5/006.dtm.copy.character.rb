# An example which copies the first character to the end of the string.
# There's an issue with this example, namely that writing a program that with any
# degree of complexity is going to be very terse.

require_relative "tm/dtm_rulebook"
require_relative "tm/dtm"
require_relative "tm/tape"
require_relative "tm/tm_rule"
require_relative "tm/tm_configuration"

rulebook = DTMRulebook.new([
  # state 1: read the first character from the tape
  TMRule.new(1, "a", 2, "a", :right), # remember a
  TMRule.new(1, "b", 3, "b", :right), # remember b
  TMRule.new(1, "c", 4, "c", :right), # remember c

  # state 2: scan right looking for end of string (remembering a)
  TMRule.new(2, "a", 2, "a", :right), # skip a
  TMRule.new(2, "b", 2, "b", :right), # skip b
  TMRule.new(2, "c", 2, "c", :right), # skip c
  TMRule.new(2, "_", 5, "a", :right), # find blank, write a

  # state 3: scan right looking for end of string (remembering b)
  TMRule.new(3, "a", 3, "a", :right), # skip a
  TMRule.new(3, "b", 3, "b", :right), # skip b
  TMRule.new(3, "c", 3, "c", :right), # skip c
  TMRule.new(3, "_", 5, "b", :right), # find blank, write b

  # state 4: scan right looking for end of string (remembering c)
  TMRule.new(4, "a", 4, "a", :right), # skip a
  TMRule.new(4, "b", 4, "b", :right), # skip b
  TMRule.new(4, "c", 4, "c", :right), # skip c
  TMRule.new(4, "_", 5, "c", :right),  # find blank, write c
])
tape = Tape.new([], "b", ["c", "b", "c", "a"], "_")
dtm = DTM.new(TMConfiguration.new(1, tape), [5], rulebook)
dtm.run
puts dtm.current_configuration.tape
