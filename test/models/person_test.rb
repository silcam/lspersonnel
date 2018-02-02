require 'test_helper'

class PersonTest < ActiveSupport::TestCase

  test "that a person can be created" do
    person = Person.new
    refute_nil(person)
  end

  test "Validity" do
    person = Person.new
    refute(person.valid?, "should not be valid without any attributes")

    person.first_name = "FNAME"
    person.last_name = "LNAME"
    person.nationality = nationalities :samoan
    person.title = titles :mechanic

    assert(person.valid?, "first and last names should make valid")
  end

  test "person can be associated with language through involvement" do
    region = Region.where(region_code: "CM-AD").first
    assert(region.valid?, "region should be valid")

    person = Person.new
    person.first_name = "BOB"
    person.last_name = "OBBO"
    person.nationality = nationalities :samoan
    person.title = titles :mechanic
    assert(person.valid?, "Person should be valid")

    cf = Language.new
    cf.name = "Camfranglais"
    cf.region = region
    assert(cf.valid?, "Camfranglais should be valid")

    cfinvolvement = Involvement.new
    cfinvolvement.level = InvolvementLevel::PRIMARY.id # need to be enum
    cfinvolvement.language = cf

    person.involvements << cfinvolvement
    assert(cfinvolvement.valid?, "Camfranglais involvement should be valid")

    if (cfinvolvement.valid?)
      cfinvolvement.save
    end

    # verify validity
    assert_equal(1, person.involvements.size, "a person has an involvement now")
    assert_equal(cf.name, cfinvolvement.language.name, "camfranglais is correct")

    assert_equal(1, person.languages.size, "a person has a language now")
    assert_equal(1, cf.people.size, "a language has a person now")


    # many to many
    person_two = Person.new
    person_two.first_name = "TOM"
    person_two.last_name = "OTMO"
    person_two.nationality = nationalities :samoan
    person_two.title = titles :mechanic
    assert(person_two.valid?, "person two is valid")

    vama = Language.new
    vama.name = "Vama"
    vama.region = region
    assert(vama.valid?, "vama is valid")

    vamainvolvement_two = Involvement.new
    vamainvolvement_two.level = InvolvementLevel::TERTIARY.id
    vamainvolvement_two.language = vama
    vamainvolvement_two.person = person_two
    assert(vamainvolvement_two.valid?, "should be valid")
    vamainvolvement_two.save

    vamainvolvement = Involvement.new
    vamainvolvement.level = InvolvementLevel::PRIMARY.id
    vamainvolvement.language = vama
    vamainvolvement.person = person
    assert(vamainvolvement.valid?, "should be valid")
    vamainvolvement.save

    assert_equal(1, person_two.languages.size, "should have 1")
    assert_equal(2, person.languages.size, "should have 2")
    assert_equal(2, vama.people.size, "should have 2")

    assert_equal(2, Involvement.where(person: person).size,
        "person one should have 2 involvements")
  end

  test "CABTAL attribute" do

    person_two = people :two
    assert_equal(false, person_two.cabtal)
    assert_equal(false, person_two.cabtal?)

    person_three = people :three
    assert_equal(true, person_three.cabtal)
    assert_equal(true, person_three.cabtal?)

    cabtal_people = Person.all_cabtal
    assert_equal(1, cabtal_people.size, "should return 1")
    assert_equal("Three", cabtal_people.first.last_name, "Three should be in list")
  end

  test "Title and Nationality are associated objects" do
    person_two = people :two

    person_two.nationality = nationalities :samoan
    person_two.title = titles :assistant
  end

  test "next_expiration_date" do
    on_date(Date.new(2018,2,1)) do
      person_one = people :one
      assert_equal(2, person_one.research_permits.size)
      # should be from :first, not :beforefirst
      assert_equal("2022-01-12", person_one.next_permit_expiration.to_s)
    end
  end

  test "next_leave_start_date" do
    on_date(Date.new(2018,2,1)) do
      person_one = people :one

      person_one.leaves << leaves(:leave_2018)
      person_one.leaves << leaves(:leave_2019)

      # should be 2018 and not 2019, or another date
      assert_equal("2018-02-21", person_one.next_leave_start_date.to_s)
    end
  end

end
