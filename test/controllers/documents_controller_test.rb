require 'test_helper'

class DocumentsControllerTest < ActionDispatch::IntegrationTest

  def setup
    do_login
  end

  test "Handles errors on renewal" do
    newguy = people :newguy

    # new guy has no permits and will create
    # an error if he tries to print a renewal
    # for a permit.
    get person_renew_permit_doc_path(newguy)
    assert_redirected_to person_documents_path(newguy)
    follow_redirect!

    assert_select("div.page-header", 1)
    assert_select("p#document-error", {
        :count => 1,
        :text => /Error creating renewal/
      }, "shows correct error when a user has no permits to renew")
    assert_response :success
  end

end
