# Moving on to non-deterministic finite automata

# Relaxing the determinism constraints has produced an imaginary machine that is very different from the real, deterministic computers we’re familiar with. An NFA deals in possibilities rather than certainties; we talk about its behavior in terms of what can happen rather than what will happen.

# We’re using the Set class, from Ruby’s standard library, to store the collection of possible states returned by #next_states. We could have used an Array, but Set has three useful features:
# 1. It automatically eliminates duplicate elements. Set[1,2,2,3,3,3] is equal to Set[1,2,3].
# 2. It ignores the order of elements. Set[3,2,1] is equal to Set[1,2,3].
# 3. It provides standard set operations like intersection (#&), union (# +), and subset testing (#subset?).

# Assignment: create a rulebook for a non-deterministic finite automaton according to the below contract.

# >> rulebook = NFARulebook.new([
#     FARule.new(1, 'a', 1), FARule.new(1, 'b', 1), FARule.new(1, 'b', 2), FARule.new(2, 'a', 3), FARule.new(2, 'b', 3),
#     FARule.new(3, 'a', 4), FARule.new(3, 'b', 4)
#     ])
#     => #<struct NFARulebook rules=[...]>
#     >> rulebook.next_states(Set[1], 'b') => #<Set: {1, 2}>
#     >> rulebook.next_states(Set[1, 2], 'a') => #<Set: {1, 3}>
#     >> rulebook.next_states(Set[1, 3], 'b') => #<Set: {1, 2, 4}>

require 'set'

class FARule < Struct.new(:current_state, :character, :next_state)
    def applies_to?(state, character)
        self.current_state == state and self.character == character
    end

    def follow
        next_state
    end

    def inspect
        "#<FARule #{state.inspect} --#{character}--> #{next_state.inspect}>"
    end
end

class NFARulebook < Struct.new(:rules)
    def next_states(states, character)
        states.flat_map{ |state| follow_rule(state, character) }.to_set
    end

    def follow_rule(state, character)
        rules_applies_for(state, character).map(&:follow)
    end

    def rules_applies_for(state, character)
        rules.select {|rule| rule.applies_to?(state, character)}
    end
end

rulebook = NFARulebook.new([
    FARule.new(1, 'a', 1), FARule.new(1, 'b', 1), FARule.new(1, 'b', 2), FARule.new(2, 'a', 3), FARule.new(2, 'b', 3),
    FARule.new(3, 'a', 4), FARule.new(3, 'b', 4)
    ])

puts rulebook.next_states(Set[1], 'b').inspect # => #<Set: {1, 2}>
puts rulebook.next_states(Set[1, 2], 'a').inspect # => #<Set: {1, 3}>
puts rulebook.next_states(Set[1, 3], 'b').inspect # => #<Set: {1, 2, 4}>
