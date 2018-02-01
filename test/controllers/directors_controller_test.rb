require "test_helper"

describe DirectorsController do
  let(:director) { directors :one }

  before(:each) do
    do_login
  end

  it "gets index" do
    get directors_url
    value(response).must_be :success?
  end

  it "gets new" do
    get new_director_url
    value(response).must_be :success?
  end

  it "creates director" do
    expect {
      post directors_url, params: { director: { current: '0', name: 'Mr. DG', title: 'DG' } }
    }.must_change "Director.count"

    must_redirect_to directors_path()
  end

  it "gets edit" do
    get edit_director_url(director)
    value(response).must_be :success?
  end

  it "updates director" do
    patch director_url(director), params: { director: { current: '1', name: 'Mrs. DG', title: 'DG2' } }
    must_redirect_to directors_path()
  end

  it "destroys director" do
    expect {
      delete director_url(director)
    }.must_change "Director.count", -1

    must_redirect_to directors_path
  end
end
