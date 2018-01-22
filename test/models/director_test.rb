require "test_helper"

class DirectorTest < ActiveSupport::TestCase

  test "validity" do
    director = Director.new
    refute(director.valid?, "should not be valid without data")
    director.name = "Mr Director"
    refute(director.valid?, "still not valid without title")
    director.title = "Director Général"
    assert(director.valid?, "should be valid now")
  end

end
