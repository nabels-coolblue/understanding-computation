# We can use non-determinism and free moves to recognize palindromes, to prevent having to inject a special character
# in the middle of the string.

require "set"
require_relative "pda/pda_rule"
require_relative "pda/pda_configuration"

class Stack < Struct.new(:contents)
  def push(character)
    Stack.new([character] + contents)
  end

  def pop
    Stack.new(contents.drop(1))
  end

  def top
    contents.first
  end

  def inspect
    "#<Stack (#{top})#{contents.drop(1).join}>"
  end
end

class NPDARulebook < Struct.new(:rules)
  def next_configurations(configurations, character)
    configurations.flat_map { |config| follow_rules_for(config, character) }.to_set
  end

  def follow_rules_for(configuration, character)
    rules_for(configuration, character).map { |rule| rule.follow(configuration) }
  end

  def rules_for(configuration, character)
    rules.select { |rule| rule.applies_to?(configuration, character) }
  end

  def follow_free_moves(configurations)
    more_configurations = next_configurations(configurations, nil)

    if more_configurations.subset?(configurations)
      configurations
    else
      follow_free_moves(configurations + more_configurations)
    end
  end
end

class NPDA < Struct.new(:current_configurations, :accept_states, :rulebook)
  def accepting?
    current_configurations.any? { |config| accept_states.include?(config.state) }
  end

  def read_character(character)
    self.current_configurations =
      rulebook.next_configurations(current_configurations, character)
  end

  def read_string(string)
    string.chars.each do |character|
      read_character(character)
    end
  end

  def current_configurations
    rulebook.follow_free_moves(super)
  end
end

class NPDADesign < Struct.new(:start_state, :bottom_character,
                              :accept_states, :rulebook)
  def accepts?(string)
    to_npda.tap { |npda| npda.read_string(string) }.accepting?
  end

  def to_npda
    start_stack = Stack.new([bottom_character])
    start_configuration = PDAConfiguration.new(start_state, start_stack)
    NPDA.new(Set[start_configuration], accept_states, rulebook)
  end
end

# Compose a rulebook with free moves
rulebook = NPDARulebook.new([
  PDARule.new(1, "a", 1, "$", ["a", "$"]),
  PDARule.new(1, "a", 1, "a", ["a", "a"]),
  PDARule.new(1, "a", 1, "b", ["a", "b"]),
  PDARule.new(1, "b", 1, "$", ["b", "$"]),
  PDARule.new(1, "b", 1, "a", ["b", "a"]),
  PDARule.new(1, "b", 1, "b", ["b", "b"]),
  PDARule.new(1, nil, 2, "$", ["$"]),
  PDARule.new(1, nil, 2, "a", ["a"]),
  PDARule.new(1, nil, 2, "b", ["b"]),
  PDARule.new(2, "a", 2, "a", []),
  PDARule.new(2, "b", 2, "b", []),
  PDARule.new(2, nil, 3, "$", ["$"]),
])

# Determine the starting state (1)
configuration = PDAConfiguration.new(1, Stack.new(["$"]))

# Set up the NPDA to allow inputs when they've ended up in the accept state (3)
npda = NPDA.new(Set[configuration], [3], rulebook)

puts npda.accepting?
# true
puts npda.current_configurations.inspect
# <Set: {#<struct PDAConfiguration state=1, stack=#<Stack ($)>>, #<struct PDAConfiguration state=2, stack=#<Stack ($)>>, #<struct PDAConfiguration state=3, stack=#<Stack ($)>>}>

npda.read_string("abb")
puts npda.accepting?
# false
puts npda.current_configurations.inspect
# <Set: {#<struct PDAConfiguration state=1, stack=#<Stack (b)ba$>>, #<struct PDAConfiguration state=2, stack=#<Stack (a)$>>, #<struct PDAConfiguration state=2, stack=#<Stack (b)ba$>>}>

npda.read_character("a")
puts npda.accepting?
# true
puts npda.current_configurations.inspect
# <Set: {#<struct PDAConfiguration state=1, stack=#<Stack (a)bba$>>, #<struct PDAConfiguration state=2, stack=#<Stack ($)>>, #<struct PDAConfiguration state=2, stack=#<Stack (a)bba$>>, #<struct PDAConfiguration state=3, stack=#<Stack ($)>>}>

npda_design = NPDADesign.new(1, "$", [3], rulebook)
puts npda_design.accepts?("abba")
# true
puts npda_design.accepts?("babbaabbab")
# true
puts npda_design.accepts?("abb")
# false
puts npda_design.accepts?("baabaa")
# false
