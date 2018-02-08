require 'test_helper'

class DepartmentTest < ActiveSupport::TestCase

  test "gender format and requirement" do
    new_d = Department.new
    new_d.region = regions :South
    new_d.name = "AMAZING DEPARTMENT"

    refute(new_d.valid?, "should not be valid")
    assert(new_d.errors.messages.has_key?(:gender), "should have gender error")

    new_d.gender = "male"
    refute(new_d.valid?, "should not be valid")
    assert(new_d.errors.messages.has_key?(:gender), "should have gender error")

    new_d.gender = "F"
    assert(new_d.valid?, "should be valid with f")
    refute(new_d.errors.messages.has_key?(:gender), "should not have gender error")

    new_d.gender = "M"
    assert(new_d.valid?, "should be valid with f")
    refute(new_d.errors.messages.has_key?(:gender), "should not have gender error")

    new_d.gender = "G"
    refute(new_d.valid?, "should not be valid")
    assert(new_d.errors.messages.has_key?(:gender), "should have gender error")
  end

  test "that name is required" do
    new_d = Department.new
    new_d.region = regions :South
    new_d.gender = "M"

    refute(new_d.valid?, "should not be valid")
    assert(new_d.errors.messages.has_key?(:name), "should have name error")

    # set name, and things are good.
    new_d.name = "Department NAME"
    assert(new_d.valid?, "should not be valid")
    refute(new_d.errors.messages.has_key?(:name), "should not have name error")
  end

  test "that departments can have many languages" do
    this_d = Department.new
    this_d.name = "Océan"
    this_d.gender = "M"
    this_d.region = regions :South

    ewondo = languages :Ewondo
    english = languages :English

    this_d.languages << ewondo
    this_d.languages << english

    assert_equal(2, this_d.languages.size, "Dept should have 2 languages now")
    assert(this_d.valid?, "is valid")
  end

  test "that languages can have many departments" do
    ewondo = languages :Ewondo
    assert_equal(1, ewondo.departments.size, "Language Should have 1 departments first")

    r_n = regions :North
    r_s = regions :South

    dept1 = Department.new
    dept1.name = "Noun"
    dept1.gender = "M"
    dept1.region = r_n

    dept2 = Department.new
    dept2.name = "Océan"
    dept2.gender = "M"
    dept2.region = r_s

    ewondo.departments << dept1
    ewondo.departments << dept2

    assert_equal(3, ewondo.departments.size, "Language Should have 2 departments now")
    assert(ewondo.valid?, "ewondo is valid")
  end

end
