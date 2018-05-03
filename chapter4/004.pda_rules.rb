# Rules for pushdown automata have the following properties.

# The state, character and next_state need to match the current configuration of the machine in order for the rule to be applied
# - state           : the state the rule can act on (1, 2, 3, etc)
# - pop_character   : needs to match the topmost stack character ('(', ')', etc)
# - character       : needs to match the next input character

# - next_state      : if the rule applies, the machine should move to the specified state
# - push_characters : after the pop_character gets popped off the stack (when moving to the next_state), these characters are pushed

# This example is to introduce the concept of following a rule. If the machine is in a fit configuration, so that the rule applies,
# move to the next configuration.

require_relative 'data_structures/_all'
require_relative 'pda/_all'

rule = PDARule.new(1, '(', 2, '$', ['b', '$'])
puts rule
# <PDARule 
#         state=1
#         character="(">
#         next_state=2
#         pop_character="$"
#         push_characters=["b", "$"]>

configuration = PDAConfiguration.new(1, Stack.new(['$']))
puts configuration
# <PDAConfiguration 
# state=1
# stack="#<Stack ($)>">

follow = rule.follow(configuration)
puts follow

>> rulebook = DPDARulebook.new([
    PDARule.new(1, '(', 2, '$', ['b', '$']),
    PDARule.new(2, '(', 2, 'b', ['b', 'b']),
    PDARule.new(2, ')', 2, 'b', []),
    PDARule.new(2, nil, 1, '$', ['$'])
    ])

class DPDARulebook < Struct.new()

# => #<struct DPDARulebook rules=[…]>
# >> configuration = rulebook.next_configuration(configuration, '(')
# => #<struct PDAConfiguration state=2, stack=#<Stack (b)$>>
# >> configuration = rulebook.next_configuration(configuration, '(')
# => #<struct PDAConfiguration state=2, stack=#<Stack (b)b$>>
# >> configuration = rulebook.next_configuration(configuration, ')')
# => #<struct PDAConfiguration state=2, stack=#<Stack (b)$>>