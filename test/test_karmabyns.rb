require 'test/unit'
require File.dirname(__FILE__) + '/../lib/karmabyns.rb'

class TestKarmabyns < Test::Unit::TestCase
  
  def karma(array)
    Karmabyns.new(array)
  end
  
  def test_should_ignore_malformed_attributes
    cases = [
        karma(["1"]), 
        karma(["1","2","3"]), 
        karma(["badgers","mushrooms","snakes"]),
        karma(["0","0"]),
        karma(["2","1"]),
        karma(["1","7"])
      ]
    cases.each do |app|
      assert_raise(ArgumentError){app.process_arguments}
    end
  end

  def test_should_provide_adequate_answers_for_basic_probabilities
    cases = [
        [karma(["1","1"]),1.0/6.0],
        [karma(["1","3"]),1.0/6.0],
        [karma(["1","6"]),1.0/6.0],
        [karma(["2","2"]),1.0/36.0],
        [karma(["2","3"]),2.0/36.0],
        [karma(["2","4"]),3.0/36.0],
        [karma(["2","5"]),4.0/36.0],
        [karma(["2","6"]),5.0/36.0],
        [karma(["2","7"]),6.0/36.0],
        [karma(["2","8"]),5.0/36.0],
        [karma(["2","9"]),4.0/36.0],
        [karma(["2","10"]),3.0/36.0],
        [karma(["2","11"]),2.0/36.0],
        [karma(["2","12"]),1.0/36.0],
      ]
      cases.each do |app|
        assert_in_delta(app[1], app[0].run, app[1]/1000.0)
      end
  end
  
  def test_all_probabilities_should_add_up_to_one
    sum = (10..60).inject(0) do |sum, value|
      sum + karma(["10",value]).run
    end
    assert_in_delta(1.0, sum, 2 ** -20)
  end
end