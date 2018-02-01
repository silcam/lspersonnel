require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/autorun'
require 'minitest/mock'
require 'minitest/reporters'
require 'minitest/rails/capybara'

Minitest::Reporters.use!

def do_login()
  user = users :login_user
  OmniAuth.config.test_mode = true
  OmniAuth.config.add_mock(:google_oauth2, { info: { email: user.email }})
  Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
  get root_url
  get login_url
  value(response).must_be :redirect?
  follow_redirect!
  follow_redirect! # second redirect needed to go through oauth process.
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def on_date(newtoday)
    Date.stub :today, newtoday do
      yield
    end
  end

end
