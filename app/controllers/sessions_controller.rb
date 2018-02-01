class SessionsController < ApplicationController

  skip_before_action :require_login, only: [:new, :create]

  def new
    if logged_in?
      redirect_to root_path
    else
      redirect_to '/auth/google_oauth2'
    end
  end

  def create
    @gmail = request.env['omniauth.auth']['info']['email']
    user = User.find_by(email: @gmail)
    if user # TODO, something more rigorous here??
            # Check authorization., etc.
      reset_user_session
      log_in user
      send_to_correct_page
    else
      session[:failed_login] = @gmail
      redirect_to root_path
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end

  def lang_toggle
    session[:original_request] = request.referer

    user = current_user
    user.toggle_language

    send_to_correct_page
  end

  private

  def send_to_correct_page
    if session[:original_request]
      redirect_to session[:original_request]
      session.delete(:original_request)
    else
      redirect_to root_path
    end
  end

  def reset_user_session
    old = session.to_hash
    reset_session
    session.merge! old
  end

end
