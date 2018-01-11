require 'test_helper'

class QuarterTest < ActiveSupport::TestCase

  test "instatiation validation" do

    assert_raise ArgumentError do
      qtr = Quarter.new
    end

    assert_raise ArgumentError do
      qtr = Quarter.new(2017,99)
    end

    assert_raise ArgumentError do
      qtr = Quarter.new(-1,1)
    end

    assert_nothing_raised do
      qtr = Quarter.new(2018,1)
    end

  end

  test "next and previous" do

    quarter = Quarter.new(2018,1)
    assert_equal('2018Q2', quarter.next.id, "can find next quarter")

    quarter = Quarter.new(2018,2)
    assert_equal('2018Q3', quarter.next.id, "can find next quarter")

    quarter = Quarter.new(2018,3)
    assert_equal('2018Q4', quarter.next.id, "can find next quarter")

    quarter = Quarter.new(2018,4)
    assert_equal('2019Q1', quarter.next.id, "can flip to next year")

    quarter = Quarter.new(2017,4)
    assert_equal('2017Q3', quarter.previous.id, "previous works")

    quarter = Quarter.new(2017,3)
    assert_equal('2017Q2', quarter.previous.id, "previous works")

    quarter = Quarter.new(2017,2)
    assert_equal('2017Q1', quarter.previous.id, "previous works")

    quarter = Quarter.new(2017,1)
    assert_equal('2016Q4', quarter.previous.id,
        "previous can do to previous year")

    assert_equal(quarter.to_s, quarter.id, "same")
  end

  test "from date" do
    assert_equal('2018Q1', Quarter.from_date(Date.new(2018,1,1)).id)
    assert_equal('2018Q1', Quarter.from_date(Date.new(2018,2,28)).id)
    assert_equal('2018Q1', Quarter.from_date(Date.new(2018,3,31)).id)
    assert_equal('2018Q2', Quarter.from_date(Date.new(2018,4,12)).id)
    assert_equal('2018Q2', Quarter.from_date(Date.new(2018,5,12)).id)
    assert_equal('2018Q2', Quarter.from_date(Date.new(2018,6,12)).id)
    assert_equal('2018Q3', Quarter.from_date(Date.new(2018,7,1)).id)
    assert_equal('2018Q3', Quarter.from_date(Date.new(2018,8,1)).id)
    assert_equal('2018Q3', Quarter.from_date(Date.new(2018,9,1)).id)
    assert_equal('2018Q4', Quarter.from_date(Date.new(2018,10,12)).id)
    assert_equal('2018Q4', Quarter.from_date(Date.new(2018,11,12)).id)
    assert_equal('2018Q4', Quarter.from_date(Date.new(2018,12,12)).id)
  end
end
