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
