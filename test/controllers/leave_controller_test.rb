require 'test_helper'

class LeaveControllerTest < ActionDispatch::IntegrationTest

  def setup
    do_login
  end

  test "Creating leave for a person" do
    @person_one = people :one
    assert_equal(0, @person_one.leaves.size, "no leaves")

    @reason_1 = leave_reasons :medical
    @reason_2 = leave_reasons :personal

    post person_leave_index_url(@person_one), params: {
      leave: {
        start_date: '2044-01-02',
        end_date: '2044-04-02'
      },
      reason: {
        "#{@reason_1.id}": 1,
        "#{@reason_2.id}": 1
      }
    }

    assert_redirected_to person_path(@person_one)
    follow_redirect!

    assert(@response.body.index(@reason_1.reason) > 0,
        "contains updated value")
    assert(@response.body.index(@reason_2.reason) > 0,
        "contains updated value")
  end

  test "deleting associations" do

    @person_one = people :one

    leave = Leave.new
    leave.start_date = "2022-01-02"
    leave.end_date = "2022-09-02"
    leave.leave_reasons << leave_reasons(:medical)

    @person_one.leaves << leave
    assert_equal(1, @person_one.leaves.size, "should have 1 leave")

    delete person_leave_url(@person_one, leave)
    assert_redirected_to person_path(@person_one)

    assert_equal(0, @person_one.leaves.size, "should have its leave deleted")
  end

end
