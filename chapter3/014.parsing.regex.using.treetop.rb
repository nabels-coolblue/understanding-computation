# Let's try to create parsing rules that can parse the string '(a(|b))*'. We'll use Treetop to create the Abstract Syntax Tree in the SIMPLE programming language that we have thus far defined. Since we have recently given semantics to the programming language by giving the Regular Expression Patterns the capability to transform into non-deterministic finite automata, we'll be able to probe the natural language string for matches. 

require_relative 'nfa/_all'
require_relative 'regex/_all'

require 'treetop'
base_path = File.expand_path(File.dirname(__FILE__)) 
tt = Treetop.load(File.join(base_path, 'regex/pattern.treetop'))

parse_tree = PatternParser.new.parse('(a(|b))*')
puts parse_tree.inspect
# SyntaxNode+Repeat1+Repeat0 offset=0, "(a(|b))*" (to_ast,brackets):
#   SyntaxNode+Brackets1+Brackets0 offset=0, "(a(|b))" (to_ast,choose):
#     SyntaxNode offset=0, "("
#     SyntaxNode+Concatenate1+Concatenate0 offset=1, "a(|b)" (to_ast,first,rest):
#       SyntaxNode+Literal0 offset=1, "a" (to_ast)
#       SyntaxNode+Brackets1+Brackets0 offset=2, "(|b)" (to_ast,choose):
#         SyntaxNode offset=2, "("
#         SyntaxNode+Choose1+Choose0 offset=3, "|b" (to_ast,first,rest):
#           SyntaxNode+Empty0 offset=3, "" (to_ast)
#           SyntaxNode offset=3, "|"
#           SyntaxNode+Literal0 offset=4, "b" (to_ast)
#         SyntaxNode offset=5, ")"
#     SyntaxNode offset=6, ")"
#   SyntaxNode offset=7, "*"

pattern = parse_tree.to_ast
puts pattern 
# (a(|b))*

puts pattern.matches?('aa') # true
puts pattern.matches?('ab') # true
puts pattern.matches?('ababab') #true
puts pattern.matches?('abba') # false
puts pattern.matches?('b') # false
