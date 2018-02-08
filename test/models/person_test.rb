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
    person.gender = "F"

    assert(person.valid?, "first and last names and gender should make valid")
  end

  test "Gender formats" do
    person = Person.new
    refute(person.valid?, "should not be valid without any attributes")

    person.first_name = "FNAME"
    person.last_name = "LNAME"
    person.nationality = nationalities :samoan
    person.title = titles :mechanic

    person.gender = "Male"
    refute(person.valid?, "gender must be M or F")

    person.gender = "Female"
    refute(person.valid?, "gender must be M or F")

    person.gender = "F"
    assert(person.valid?, "gender must be M or F")

    person.gender = "M"
    assert(person.valid?, "gender must be M or F")

    person.gender = "U"
    refute(person.valid?, "gender must be M or F")
  end

  # TODO: This test is really long
  test "person can be associated with language through involvement" do
    region = Region.where(region_code: "CM-AD").first
    assert(region.valid?, "region should be valid")

    person = Person.new
    person.first_name = "BOB"
    person.last_name = "OBBO"
    person.nationality = nationalities :samoan
    person.title = titles :mechanic
    person.gender = "M"
    assert(person.valid?, "Person should be valid")

    r = regions :Centre

    d = Department.new
    d.name = "Mfoundi"
    d.gender = "M"
    d.region = r

    cf = Language.new
    cf.name = "Camfranglais"
    cf.departments << d
    cf.valid?
    d.valid?
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
    person_two.gender = "M"
    person_two.title = titles :mechanic
    assert(person_two.valid?, "person two is valid")

    r = regions :North

    d = Department.new
    d.name = "Noun"
    d.gender = "M"
    d.region = r

    vama = Language.new
    vama.name = "Vama"
    vama.departments << d
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

  test "adj_ending" do
    person_male = people :male
    assert_equal("é", person_male.adj_ending)
    person_female = people :female
    assert_equal("ée", person_female.adj_ending)
  end

  test "researcher_name" do
    person_male = people :two
    assert_equal("M. TWO Person", person_male.formal_name)

    person_male = people :female
    assert_equal("Mme. PERSON Female", person_male.formal_name)
  end

  test "researcher_name_short" do
    person_male = people :two
    assert_equal("M. TWO", person_male.formal_name_short)

    person_male = people :male
    assert_equal("M. PERSON", person_male.formal_name_short)
  end

  test "filename format" do
    person_female = people :female
    assert_equal("female_person", person_female.filename)
  end

  test "Research Permit" do
    on_date(Date.new(2018,2,5)) do
      person_one = people :one
      assert_equal(2, person_one.research_permits.size, "should have 2")
      assert_equal("1234-1234-1234", person_one.research_permit_number)

      # Add and expire the old number
      first = research_permits :first
      assert(first.language, "should have a language")
      assert_equal("English", first.language.name, "should be English")
      first.expiry_date = "2018-01-01"
      first.valid?
      assert(first.valid?, "should be valid")
      first.save

      new_permit = ResearchPermit.new
      new_permit.expiry_date = "2022-01-01"
      new_permit.issue_date = "2018-01-01"
      new_permit.submission_date = "2017-12-21"
      new_permit.identifier = "1234-1234-1245"
      new_permit.language = languages :English
      person_one.research_permits << new_permit

      assert_equal(3, person_one.research_permits.size, "should have 3")

      assert_equal(new_permit.identifier, person_one.research_permit_number,
          "new permit is now the identifier to be used")
    end
  end

  test "if someone doesn't have a valid permit, it should return null" do
    person_two = people :two
    assert_nil(person_two.research_permit_number)
  end

  test "Previous Letter Date" do
    on_date(Date.new(2018,2,5)) do
      person_one = people :one

      assert_equal("2017-01-12", person_one.previous_letter_date.to_s)

      new_permit = ResearchPermit.new
      new_permit.expiry_date = "2022-01-01"
      new_permit.issue_date = "2018-02-15"
      new_permit.submission_date = "2018-02-01"
      new_permit.identifier = "1234-1234-1245"
      new_permit.language = languages :English
      person_one.research_permits << new_permit

      # This advances the submission date to the new date
      assert_equal("2018-02-01", person_one.previous_letter_date.to_s)
    end
  end

  test "Research Request Period and Future Plans" do
    activities =  "Learn Karate"
    period = "un quinquennat"

    person_one = people :one
    person_one.future_activities = activities
    person_one.request_period = period

    assert_equal(activities, person_one.future_activities, "good activities")
    assert_equal(period, person_one.request_period, "good period")

    assert(person_one.valid?, "person one is valid")
  end

  test "Request Period uses correct grammar" do
    person_one = people :one

    person_one.request_period = "un an"
    assert_equal("d'un an", person_one.request_period_for_letter,
        "can format request period correctly")

    person_one.request_period = "un quinquennat"
    assert_equal("d'un quinquennat", person_one.request_period_for_letter,
        "can format request period correctly")

    person_one.request_period = "sept mois"
    assert_equal("de sept mois", person_one.request_period_for_letter,
        "can format request period correctly")
  end

  test "Primary Language Involvement is language on letter" do
    person_one = people :one
    assert_equal(0, person_one.involvements.size, "Should not have any involvements at the beginning")

    # Now add some
    lamnso = languages :Lamnso

    inv= Involvement.new
    inv.level = InvolvementLevel::PRIMARY.id # need to be enum
    inv.language = lamnso

    person_one.involvements << inv
    assert(inv.valid?, "Involvement should be valid")
    assert(person_one.valid?, "Person should be valid")

    assert_equal("sur la langue lamnso parlée dans le département du Faro", person_one.research_statement,
        "Can find research statement for user's research languages")
  end

  test "that languages with many departments create a correct research statement" do
    person_one = people :one
    assert_equal(0, person_one.involvements.size, "Should not have any involvements at the beginning")

    ewondo = languages :Ewondo
    assert_equal(1, ewondo.departments.size, "should have 1")

    faro = departments :Faro
    ewondo.departments << faro

    assert_equal(2, ewondo.departments.size, "now should have 2")
    assert(ewondo.valid?, "valid now")

    inv= Involvement.new
    inv.level = InvolvementLevel::PRIMARY.id # need to be enum
    inv.language = ewondo

    person_one.involvements << inv
    assert(inv.valid?, "Involvement should be valid")
    assert(person_one.valid?, "Person should be valid")

    assert_equal(
        "sur la langue ewondo parlée dans les départements du Mfoundi et du Faro",
          person_one.research_statement, "should make correct research statement")
  end

  test "research statement with three and females" do
    person_one = people :one
    assert_equal(0, person_one.involvements.size, "Should not have any involvements at the beginning")

    ewondo = languages :Ewondo
    assert_equal(1, ewondo.departments.size, "should have 1")

    faro = departments :Faro
    ewondo.departments << faro

    mvila = departments :Mvila
    ewondo.departments << mvila

    assert_equal(3, ewondo.departments.size, "now should have 3")
    assert(ewondo.valid?, "valid now")

    inv= Involvement.new
    inv.level = InvolvementLevel::PRIMARY.id # need to be enum
    inv.language = ewondo

    person_one.involvements << inv
    assert(inv.valid?, "Involvement should be valid")
    assert(person_one.valid?, "Person should be valid")

    assert_equal(
        "sur la langue ewondo parlée dans les départements du Mfoundi, et du Faro, et de la Mvila",
          person_one.research_statement, "should make correct research statement")
  end

  test "research statement with exceptions" do
    person_one = people :one
    assert_equal(0, person_one.involvements.size, "Should not have any involvements at the beginning")

    ewondo = languages :Ewondo
    assert_equal(1, ewondo.departments.size, "should have 1")

    ocean = departments :Ocean
    ewondo.departments << ocean
    hp = departments :HautsPlateaux
    ewondo.departments << hp

    assert_equal(3, ewondo.departments.size, "now should have 3")
    assert(ewondo.valid?, "valid now")

    inv= Involvement.new
    inv.level = InvolvementLevel::PRIMARY.id # need to be enum
    inv.language = ewondo

    person_one.involvements << inv
    assert(inv.valid?, "Involvement should be valid")
    assert(person_one.valid?, "Person should be valid")

    assert_equal(
        "sur la langue ewondo parlée dans les départements du Mfoundi, et de l'Océan, et des Hauts-Plateaux",
          person_one.research_statement, "should make correct research statement")
  end

  test "research statement with multiple languages" do
    person_one = people :one
    assert_equal(0, person_one.involvements.size, "Should not have any involvements at the beginning")

    ewondo = languages :Ewondo
    assert_equal(1, ewondo.departments.size, "should have 1")

    ocean = departments :Ocean
    ewondo.departments << ocean
    hp = departments :HautsPlateaux
    ewondo.departments << hp

    assert_equal(3, ewondo.departments.size, "now should have 3")
    assert(ewondo.valid?, "valid now")

    inv= Involvement.new
    inv.level = InvolvementLevel::PRIMARY.id # need to be enum
    inv.language = ewondo

    lamnso = languages :Lamnso
    inv2= Involvement.new
    inv2.level = InvolvementLevel::PRIMARY.id # need to be enum
    inv2.language = lamnso

    person_one.involvements << inv
    person_one.involvements << inv2
    assert(inv.valid?, "Involvement should be valid")
    assert(person_one.valid?, "Person should be valid")

    assert_equal(
        "sur les langues ewondo et lamnso parlées dans les départements du Mfoundi, et de l'Océan, et des Hauts-Plateaux, et du Faro",
          person_one.research_statement, "should make correct research statement")

    # Add another language to make 3
    sso = languages :Sso
    inv3= Involvement.new
    inv3.level = InvolvementLevel::PRIMARY.id # need to be enum
    inv3.language = sso
    person_one.involvements << inv3
    assert_equal(3, person_one.involvements.size, "should be 3 now")

    assert_equal(
        "sur les langues ewondo, et lamnso, et sso parlées dans les départements du Mfoundi, et de l'Océan, et des Hauts-Plateaux, et du Faro",
          person_one.research_statement, "should make correct research statement")
  end

end
