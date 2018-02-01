require 'test_helper'

class PeopleControllerTest < ActionDispatch::IntegrationTest

  def setup
    do_login
  end

  test "edit form" do
    @person_one = people :one
    get edit_person_url(@person_one)

    assert_response :success
  end

  test "can show" do
    @person_one = people :one
    get person_url(@person_one)

    assert_response :success
  end

  test "can update person" do
    @person_one = people :one
    patch person_url(@person_one), params: {
        person: { category: "New Category" }
    }

    assert_redirected_to person_path(@person_one)
    follow_redirect!

    assert(@response.body.index("New Category") > 0,
        "contains updated value")
  end

  test "new form" do
    get new_person_url()
    assert_response :success
  end

  test "attach" do
    @person_one = people :one
    @ewondo = languages :Ewondo


    assert_equal(0, @person_one.involvements.size, "no involvements")

    post attach_language_url(@person_one), params: {
        person: { language_ids: @ewondo.id,
        involvement_ids: InvolvementLevel.get(:primary).id }
    }

    assert_redirected_to person_path(@person_one)
    follow_redirect!

    assert(@response.body.index("Ewondo") > 0,
        "contains updated value")
    assert(@response.body.index("Primary") > 0,
        "contains updated value")
  end

end
