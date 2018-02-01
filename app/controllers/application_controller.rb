class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper
  include ApplicationHelper
  include RedirectToReferrer

  before_action :require_login, :log_access, :set_locale, :store_redirect

  private

  def require_login
    if logged_in?
      # renew_aging_session ?
      return
    end

    if request.path == root_path
      @failed_login_email = session[:failed_login]
      session.delete :failed_login
      render 'shared/welcome'
    else
      session[:original_request] = request.path
      redirect_to '/auth/google_oauth2'
    end
  end

  def log_access
    unless current_user.nil?
      current_user.update(last_login: DateTime.now)
    end
  end

  def set_locale
    I18n.locale = current_user.try(:language) || I18n.default_locale
  end
end
