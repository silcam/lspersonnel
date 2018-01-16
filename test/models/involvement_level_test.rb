require 'test_helper'

class InvolvementLevelTest < ActiveSupport::TestCase

  test "Initialization" do

    il = InvolvementLevel.new(10,"TEMPORARY")
    refute_nil(il, "should not be nil when just created")

  end

  test "Default Constants" do
    refute_nil(InvolvementLevel::PRIMARY)
  end


  test "by ID" do
    assert_equal("Primary", InvolvementLevel.id(1).name)
  end

  test "by symbol" do
    assert_equal("Primary", InvolvementLevel.get(:primary).name)
  end

  test "by name" do
    assert_equal("Primary", InvolvementLevel.get("Primary").name)
  end

end
