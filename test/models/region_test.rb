require 'test_helper'

class RegionTest < ActiveSupport::TestCase

  test "that departments have regions" do
    d = Department.new
    d.name = "Océan"
    d.gender = "M"
    refute(d.valid?, "not valid")

    d.region = regions :South
    assert(d.valid?, "valid now with region")
  end

end
