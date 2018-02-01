require 'test_helper'

class ResearchPermitsControllerTest < ActionDispatch::IntegrationTest

  def setup
    do_login
  end

  test "new form" do
    @person_one = people :one
    get new_person_research_permit_path(@person_one)
    assert_response :success
  end

  test "edit form" do
    @person_one = people :one
    @first_permit = research_permits :first
    get edit_person_research_permit_path(@person_one, @first_permit)

    assert_response :success
  end

  test "can show on person page" do
    @person_one = people :one
    assert_equal(1, @person_one.research_permits.size, "should have 1 permit")
    @permit = @person_one.research_permits.first

    get person_url(@person_one)

    assert_response :success
    assert(@response.body.index(@permit.identifier) > 0,
      "person#show contains permit")
  end

  test "can update permit" do
    new_identifier = "X1234X"

    @person_one = people :one
    @permit = @person_one.research_permits.first
    @language = languages :English

    patch person_research_permit_path(@person_one, @permit), params: {
        research_permit: {
          identifier: new_identifier,
          expiry_date: '2029-09-09',
          language_id: @language.id
        }
    }

    assert_redirected_to person_path(@person_one)
    follow_redirect!

    assert_select "h2#person-name"
    assert(@response.body.index(new_identifier) > 0,
        "contains updated identifier")
  end

end
