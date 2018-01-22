require "test_helper"

describe NationalitiesController do
  let(:nationality) { nationalities :one }

  it "gets index" do
    get nationalities_url
    value(response).must_be :success?
  end

  it "gets new" do
    get new_nationality_url
    value(response).must_be :success?
  end

  it "creates nationality" do
    expect {
      post nationalities_url, params: { nationality: { nationality: 'Obristrani' } }
    }.must_change "Nationality.count"

    must_redirect_to nationalities_path()
  end

  it "gets edit" do
    get edit_nationality_url(nationality)
    value(response).must_be :success?
  end

  it "updates nationality" do
    patch nationality_url(nationality), params: { nationality: { nationality: 'Kolechian' } }
    must_redirect_to nationalities_path()
  end

  it "destroys nationality" do
    expect {
      delete nationality_url(nationality)
    }.must_change "Nationality.count", -1

    must_redirect_to nationalities_path
  end
end
