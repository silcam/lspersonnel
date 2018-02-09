require 'test_helper'

class LanguagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    do_login
  end

  test "index" do
    get languages_url()

    assert_response :success
  end

  test "new form" do
    get new_language_url()

    assert_response :success
  end

  test "edit form" do
    @language = languages :Sso
    get edit_language_url(@language)

    assert_response :success
  end

  test "update language" do
    @language = languages :Sso

    patch language_url(@language), params: {
      language: { name: "Swo" }
    }

    assert_redirected_to languages_path()
    follow_redirect!

    assert(@response.body.index("Swo") > 0, "contains new name")
  end

end
