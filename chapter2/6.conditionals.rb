# Create a machine that can run the next statement, and produces the following output.

# >> Machine.new( If.new(
#     Variable.new(:x), Assign.new(:y, Number.new(1)), Assign.new(:y, Number.new(2))
#     ),
#     { x: Boolean.new(true) } ).run

# Output:

# if (x) { y = 1 } else { y = 2 }, {:x=>«true»} 
# if (true) { y = 1 } else { y = 2 }, {:x=>«true»} 
# y = 1, {:x=>«true»}
# do-nothing, {:x=>«true», :y=>«1»}


