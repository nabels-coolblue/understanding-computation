# Understanding Computation, page 120

# To really exploit the potential of the stack, we need a tougher problem that’ll force us
# to store structured information. The classic example is recognizing palindromes: as we
# read the input string, character by character, we have to remember what we see; once
# we pass the halfway point, we check our memory to decide whether the characters we
# saw earlier are now appearing in reverse order.

require_relative 'data_structures/_all'
require_relative 'pda/_all'

rules = 
    [
        PDARule.new(1, 'a', 1, '$', ['a', '$']),
        PDARule.new(1, 'a', 1, 'a', ['a', 'a']),
        PDARule.new(1, 'a', 1, 'b', ['a', 'b']),
        PDARule.new(1, 'b', 1, '$', ['b', '$']),
        PDARule.new(1, 'b', 1, 'a', ['b', 'a']),
        PDARule.new(1, 'b', 1, 'b', ['b', 'b']),
        PDARule.new(1, 'm', 2, '$', ['$']),
        PDARule.new(1, 'm', 2, 'a', ['a']),
        PDARule.new(1, 'm', 2, 'b', ['b']),
        PDARule.new(2, 'a', 2, 'a', []),
        PDARule.new(2, 'b', 2, 'b', []),
        PDARule.new(2, nil, 3, '$', ['$'])
    ]

rulebook = DPDARulebook.new(rules)
design = DPDADesign.new(1, '$', [3], rulebook)

# The palindrome needs to have the 'm' character in the middle for the DPDA to recognize palindromes.

# Valid palindromes:
puts design.accepts?('aaaaaamaaaaaa')
puts design.accepts?('bbbbmbbbb')
puts design.accepts?('ababmbaba')
# true
# true
# true

# Invalid palindromes:
puts design.accepts?('abbambaab')
puts design.accepts?('bma')
puts design.accepts?('aaaaaamaaaaa')
# false
# false
# false
