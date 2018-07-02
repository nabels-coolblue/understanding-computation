# Create a solution to the FizzBuzz challenge using only procs

# http://imranontech.com/2007/01/24/using-fizzbuzz-to-find-developers-who-grok-coding/

(1..100).map do |i|
  if (i).modulo(15).zero?
    "FizzBuzz"
  elsif (i).modulo(5).zero?
    "Buzz"
  elsif (i).modulo(3).zero?
    "Fizz"
  else
    i.to_s
  end
end
#.each { |j| puts j } we have no way to print text to the console using only procs

# Despite its simplicity, this is quite an ambitious program if we don’t have any of the features of a programming language: it creates a range, maps over it, evaluates a big conditional, does some arithmetic with the modulo operator, uses the Fixnum#zero? predicate, uses some string literals, and turns numbers into strings with Fixnum#to_s. That’s a fair amount of built-in Ruby functionality, and we’re going to have to strip it all out and reimplement it with procs.
