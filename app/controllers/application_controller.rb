class ApplicationController < ActionController::Base
  before_action :require_authentication

  private

  def require_authentication
    resume_session || request_authentication
  end

  def resume_session
    Current.session ||= find_session_by_cookie
  end

  def find_session_by_cookie
    Session.find_by(token: cookies.signed[:session_token])
  end

  def request_authentication
    redirect_to new_session_path
  end

  def start_new_session_for(user)
    user.sessions.create!(ip_address: request.remote_ip, user_agent: request.user_agent).tap do |session|
      Current.session = session
      cookies.signed.permanent[:session_token] = { value: session.token, httponly: true, same_site: :lax }
    end
  end

  def terminate_session
    Current.session.destroy
    cookies.delete(:session_token)
  end

  def current_user
    Current.user
  end

  helper_method :current_user
end
