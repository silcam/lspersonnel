require "test_helper"

class NationalityTest < ActiveSupport::TestCase

  test "validity" do
    nat = Nationality.new
    refute(nat.valid?, "should not be valid without data")
    nat.nationality = "Samoan"
    assert(nat.valid?, "should be valid now")
  end

end
