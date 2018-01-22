require 'test_helper'

class PeriodicDocumentTest < ActiveSupport::TestCase

  test "Primary Report validations" do
    doc = PrimaryReport.new
    refute(doc.valid?, "should not be valid after creation")

    person = Person.new
    person.first_name = "FA"
    person.last_name = "LA"
    person.nationality = nationalities :samoan
    person.title = titles :mechanic

    assert(person.valid?, "person should be valid")
    person.save

    person.primary_reports << doc
    refute(doc.valid?, "should not be valid after association")

    doc.language = languages :English
    doc.submission_date = "2018-12-01"
    doc.save

    assert(doc.valid?, "should pass validation")

  end

  test "Quarterly Report validations" do
    doc = QuarterlyReport.new
    refute(doc.valid?, "should not be valid after creation")

    person = Person.new
    person.first_name = "FA"
    person.last_name = "LA"
    person.nationality = nationalities :samoan
    person.title = titles :mechanic
    assert(person.valid?, "person should be valid")
    person.save

    person.quarterly_reports << doc
    refute(doc.valid?, "should not be valid after association")

    doc.language = languages :English
    doc.submission_date = "2018-12-01"
    doc.save

    assert(doc.valid?, "should pass validation")

    qtr = Quarter.new(2018,1)
    doc.quarter = qtr
    assert_equal(qtr.id, doc.quarter, "can store a quarter in a periodic document")
  end

  test "Single Table Inheritence Tests" do

    person = Person.new
    person.first_name = "FN"
    person.last_name = "LN"
    person.nationality = nationalities :samoan
    person.title = titles :mechanic
    assert(person.valid?, "person is valid now")
    person.save

    qr = QuarterlyReport.new
    qr.language = languages :English
    qr.submission_date = "2018-01-01"
    person.quarterly_reports << qr
    assert(qr.valid?, "QR should be valid now")
    qr.save

    pr = PrimaryReport.new
    pr.language = languages :English
    pr.submission_date = "2018-01-01"
    person.primary_reports << pr
    assert(pr.valid?, "PR should be valid now")
    pr.save

    assert_equal(1, person.quarterly_reports.size, "Should have 1 QR")
    assert_equal(1, person.primary_reports.size, "Should have 1 PR")

    assert_equal(1, QuarterlyReport.all.size, "should be 1 QR")
    assert_equal(1, PrimaryReport.all.size, "should be 1 PR")

  end

end
