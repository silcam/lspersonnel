require 'test_helper'

class LanguageTest < ActiveSupport::TestCase

  test "that languages can have more than one department" do
    ewondo = languages :Ewondo
    assert_equal(1, ewondo.departments.size, "should have 1")

    faro = departments :Faro
    ewondo.departments << faro

    assert_equal(2, ewondo.departments.size, "now should have 2")
    assert(ewondo.valid?, "valid now")
  end

end
