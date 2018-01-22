require "test_helper"

class TitleTest < ActiveSupport::TestCase

  test "validity" do
    title = Title.new
    refute(title.valid?, "should not be valid without data")
    title.title = "Captain"
    assert(title.valid?, "should be valid now")
  end

end
