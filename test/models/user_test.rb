require "test_helper"

class UserTest < ActiveSupport::TestCase

  test "Users can switch language" do

    user = User.new
    assert(user.en?, "english is the default language")
    refute(user.fr?, "french is not the default language")
    assert_equal("en", user.language, "english is the language")

    user.toggle_language

    refute(user.en?, "english was toggled off")
    assert(user.fr?, "french was toggled on")
    assert_equal("fr", user.language, "english is the language")

  end

end
