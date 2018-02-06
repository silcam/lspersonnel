require 'test_helper'

class LeaveTest < ActiveSupport::TestCase

  test "Leaves can be classified" do
    on_date(Date.new(2018,1,18)) do
      @person_one = people :one

      @person_one.leaves << leaves(:leave_2010)
      assert_equal(1, @person_one.leaves.size, "should have 1 leave")
      leave_hash = Leave.leave_type_hash(@person_one)

      assert_equal(7, leave_hash.keys.size, "FIXME: should have 7 keys")

      # 2010 is old
      assert_equal(1, leave_hash[:old].size, "2010 leave should be old")
      assert_equal(1, leave_hash[:last].size, "2010 leave should be last")
      assert_equal(0, leave_hash[:future].size, "no future leaves")

      # 2020 is future
      @person_one.leaves << leaves(:leave_2020)
      assert_equal(2, @person_one.leaves.size, "should have 2 leaves now")
      leave_hash = Leave.leave_type_hash(@person_one)

      assert_equal(1, leave_hash[:old].size, "2010 leave should be old")
      assert_equal(1, leave_hash[:last].size, "2010 leave should be last")
      assert_equal(1, leave_hash[:future].size, "2020 leave is future")

      @person_one.leaves << leaves(:leave_2016)
      assert_equal(3, @person_one.leaves.size, "should have 3 leaves now")
      leave_hash = Leave.leave_type_hash(@person_one)

      assert_equal(2, leave_hash[:old].size, "2010 and 2016 should be old")
      assert_equal(1, leave_hash[:last].size, "2016 leave should be last")
      assert_equal(2016, leave_hash[:last][0].start_date.year, "last is 2016")
      assert_equal(1, leave_hash[:future].size, "2020 leave is future")
      assert_equal(0, leave_hash[:this_year].size, "none this year")
      assert_equal(0, leave_hash[:next_year].size, "none next year")

      @person_one.leaves << leaves(:leave_2019)
      assert_equal(4, @person_one.leaves.size, "should have 4 leaves now")
      leave_hash = Leave.leave_type_hash(@person_one)

      assert_equal(2, leave_hash[:old].size, "2010 and 2016 should be old")
      assert_equal(1, leave_hash[:last].size, "2016 leave should be last")
      assert_equal(2016, leave_hash[:last][0].start_date.year, "last is 2016")
      assert_equal(2, leave_hash[:future].size, "2019,2020 is future")
      assert_equal(0, leave_hash[:this_year].size, "none this year")
      assert_equal(1, leave_hash[:next_year].size, "2019 next year")
      assert_equal(2019, leave_hash[:next_year][0].start_date.year, "2019 next year")

      @person_one.leaves << leaves(:leave_2018)
      assert_equal(5, @person_one.leaves.size, "should have 5 leaves now")
      leave_hash = Leave.leave_type_hash(@person_one)

      assert_equal(2, leave_hash[:old].size, "2010 and 2016 should be old")
      assert_equal(1, leave_hash[:last].size, "2016 leave should be last")
      assert_equal(2016, leave_hash[:last][0].start_date.year, "last is 2016")
      assert_equal(3, leave_hash[:future].size, "2018,2019,2020 is future")
      assert_equal(1, leave_hash[:this_year].size, "none this year")
      assert_equal(2018, leave_hash[:this_year][0].start_date.year, "2018 this year")
      assert_equal(1, leave_hash[:next_year].size, "2019 next year")
      assert_equal(2019, leave_hash[:next_year][0].start_date.year, "2019 next year")

      @person_one.leaves << leaves(:leave_2017)
      assert_equal(6, @person_one.leaves.size, "should have 6 leaves now")
      leave_hash = Leave.leave_type_hash(@person_one)

      assert_equal(2, leave_hash[:old].size, "2010 and 2016 should be old")
      assert_equal(1, leave_hash[:last].size, "2016 leave should be last")
      assert_equal(2016, leave_hash[:last][0].start_date.year, "last is 2016")
      assert_equal(3, leave_hash[:future].size, "2018,2019,2020 is future")
      assert_equal(1, leave_hash[:this_year].size, "none this year")
      assert_equal(2018, leave_hash[:this_year][0].start_date.year, "2018 this year")
      assert_equal(1, leave_hash[:next_year].size, "2019 next year")
      assert_equal(2019, leave_hash[:next_year][0].start_date.year, "2019 next year")
      assert_equal(1, leave_hash[:current].size, "2017 is current")
      assert_equal(2017, leave_hash[:current][0].start_date.year, "2017 is current")

    end
  end

  test "People can have leaves" do

    person = Person.new
    person.first_name = "FN"
    person.last_name = "LN"
    person.nationality = nationalities :samoan
    person.title = titles :mechanic
    person.gender = "F"
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
