# == Synopsis 
#   Karmabyns, given two arguments, the number of dice to be thrown and the
#   value that is being investigated, will provide the probability of that value
#   being the total of dice being thrown.
#
# == Examples
#     karmabyns 1 6 => 0.166
#     karmabyns 2 4 => 0.083
#
# == Usage 
#   karmabyns number_of_dice value_sought
#
# == Author
#   Gilberto Apostlion
#
# == Copyright
#   Copyright (c) 2009 Gilberto Apostlion. Licensed under the MIT License:
#   http://www.opensource.org/licenses/mit-license.php

require 'date'
require 'benchmark'

class Karmabyns  
  def initialize(arguments)
    @arguments = arguments
    @cached_f = {}
  end

  # Outputs basic usage information if arguments are invalid; follows the
  # 
  def run
    begin
      process_arguments
    rescue ArgumentError
      output_usage
    end
  end
  
  # Raises an exception in case of arguments mismatch.
  def process_arguments
    if arguments_valid? 
      process_command
    else
      raise ArgumentError
    end
  end
  
  protected
  # Checks for validity of arguments
  def arguments_valid?
    return false if @arguments.length != 2
    @number = @arguments[0].to_i
    @value = @arguments[1].to_i
    true if (@number > 0 && @value > (@number-1) && @value < (@number*6+1)) 
  end
    
  # Called if arguments are out of range
  def output_usage
    print "== Usage 
    karmabyns number_of_dice value_sought"
  end
  
  # Calculates the probability and outputs it.
  def process_command
    result = f(@number, @value)
    print result
    result
  end
  
  # This method calculates probability F of gaining value of k when throwing i
  # dice. Uses exponentiation by squaring for performance boost.
  def f(i, k)
    if i == 1 && (1..6) === k 
      1.0/6.0 #Uniform distribution of probability for one die
    elsif i == 1
      0 #Out of range value
    elsif @cached_f[i] && @cached_f[i][k]
      @cached_f[i][k] #Using cached value if it exists
    else
      # Using exponentiation by squaring algorithm for determining probability
      x = i-1
      y = 1
      a = (1..k-1).inject(0) do |sum, value| 
        if (x == 1 && value > 6) || (y == 1 && (k - value) > 6)
          sum
        else
          sum + f(x,value)*f(y, k - value)
        end
      end
      # Storing the calculated value in cache
      if @cached_f[i]
        @cached_f[i][k] = a
      else
        @cached_f[i] ={}
        @cached_f[i][k] = a  
      end
    end
  end
end

# Create and run the application
#app = Karmabyns.new(ARGV)
#app.run

Benchmark.bmbm do |x|
  x.report("100") {Karmabyns.new(["100", "100"]).run}
  x.report("350") {Karmabyns.new(["100", "350"]).run}
  x.report("600") {Karmabyns.new(["100", "600"]).run}
end