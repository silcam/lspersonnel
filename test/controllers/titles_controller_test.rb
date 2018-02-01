require "test_helper"

describe TitlesController do
  let(:title) { titles :one }

  before(:each) do
    do_login
  end

  it "gets index" do
    get titles_url
    value(response).must_be :success?
  end

  it "gets new" do
    get new_title_url
    value(response).must_be :success?
  end

  it "creates title" do
    expect {
      post titles_url, params: { title: { title: "Interim Title Holder" } }
    }.must_change "Title.count"

    must_redirect_to titles_path()
  end

  it "gets edit" do
    get edit_title_url(title)
    value(response).must_be :success?
  end

  it "updates title" do
    patch title_url(title), params: { title: { title: "Title Holder" } }
    must_redirect_to titles_path()
  end

  it "destroys title" do
    expect {
      delete title_url(title)
    }.must_change "Title.count", -1

    must_redirect_to titles_path
  end
end
