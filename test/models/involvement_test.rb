require 'test_helper'

class InvolvementTest < ActiveSupport::TestCase

  test "Validity" do

    cent = Region.new
    cent.name = "Centre"

    lang = Language.new
    lang.name = "TESTLANG"
    lang.region = cent

    pers = Person.new
    pers.first_name = "BOB"
    pers.last_name = "OBB"

    involvement = Involvement.new
    refute(involvement.valid?, "shouldn't be valid w/o any associations")

    involvement.language = lang
    involvement.person = pers
    involvement.save

    refute(involvement.valid?, "shouldn't be valid w/o any attributes")

    involvement.level = "X"
    refute(involvement.valid?, "shouldn't be valid unless integer")

    involvement.level = 3
    assert(involvement.valid?, "should now be valid")
  end
end