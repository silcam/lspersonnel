require 'test_helper'

class ResearchPermitTest < ActiveSupport::TestCase

  test "something something" do
    permit = ResearchPermit.new
    refute(permit.valid?, "should not be valid")

    assert_includes(permit.errors.messages, :submission_date,
        "needs at least a submission date")
  end

end
