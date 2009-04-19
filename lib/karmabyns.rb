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
    if i == 1
      k < 7 ? 0.16666666666666667 : 0 #Uniform distribution of probability for one die
    elsif @cached_f[i] && @cached_f[i][k]
      @cached_f[i][k] #Using cached value if it exists
    else
      # Using exponentiation by squaring algorithm for determining probability
      sum = 0
      range = i < 3 ? ([k-6,1].max..[k-1,6].min) : ([k-6,1].max..k-1) 
      range.each do |value|
        sum = sum + 0.16666666666666667*f(i-1,value)
      end
      # Storing the calculated value in cache
        @cached_f[i] ||= {}
        @cached_f[i][k] = sum 
    end
  end
end

# Create and run the application
app = Karmabyns.new(ARGV)
app.run