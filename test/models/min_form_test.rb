require 'test_helper'

class MinFormTest < ActiveSupport::TestCase

  test "values" do
    assert(MinForm.first.top_left, "has top left value -- DID YOU RUN `rails db:seed`?")
  end

end
