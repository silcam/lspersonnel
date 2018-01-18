require 'test_helper'

class LeaveTest < ActiveSupport::TestCase

  test "People can have leaves" do

    person = Person.new
    person.first_name = "FN"
    person.last_name = "LN"
    assert(person.valid?, "Person should be valid")

    leave = Leave.new
    leave.start_date = '2018-01-02'
    leave.end_date = '2018-01-04'
    refute(leave.valid?, "should not be valid without association")

    reason_1 = LeaveReason.new
    reason_1.reason = "Homesick"

    reason_2 = LeaveReason.new
    reason_2.reason = "Medical"

    leave.leave_reasons << reason_1
    leave.leave_reasons << reason_2
    assert_equal(2, leave.leave_reasons.size, "should have two reasons")

    person.leaves << leave
    assert(leave.valid?, "should be valid now with association")

  end

  test "Start Date must be before End Date" do

    leave = Leave.new
    refute(leave.valid?, "should not be valid without dates")

    assert_includes(leave.errors.messages, :start_date, "has errors")
    assert_includes(leave.errors.messages, :end_date, "has errors")

    leave.start_date = "2035-11-30"
    leave.end_date = "2018-10-15"

    refute(leave.valid?, "should not be valid")
    assert_includes(leave.errors.messages, :start_date, "has errors")
    assert_includes(leave.errors.messages, :end_date, "has errors")

    leave.start_date = "2018-10-15"

    refute(leave.valid?, "should not be valid when dates are the same")
    assert_includes(leave.errors.messages, :start_date, "has errors")
    assert_includes(leave.errors.messages, :end_date, "has errors")

    leave.start_date = "2018-09-01"
    leave.valid?
    refute_includes(leave.errors.messages, :start_date, "is now valid")
    refute_includes(leave.errors.messages, :end_date, "is now valid")

  end

end
