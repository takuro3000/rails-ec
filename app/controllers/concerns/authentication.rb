# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :set_current_session
    helper_method :signed_in?, :current_user
  end

  private

  def set_current_session
    Current.session = Session.find_by(id: cookies.signed[:session_id])
  end

  def signed_in?
    Current.user.present?
  end

  def current_user
    Current.user
  end

  def sign_in(user)
    session = user.sessions.create!(
      ip_address: request.remote_ip,
      user_agent: request.user_agent
    )
    cookies.signed.permanent[:session_id] = { value: session.id, httponly: true }
    Current.session = session
  end

  def sign_out
    Current.session&.destroy
    cookies.delete(:session_id)
    Current.session = nil
  end

  def require_authentication
    unless signed_in?
      redirect_to sign_in_path, alert: "ログインが必要です"
    end
  end
end
