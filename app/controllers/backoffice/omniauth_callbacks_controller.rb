class Backoffice::OmniauthCallbacksController < ApplicationController
  layout "backoffice"

  def github
    handle_oauth("github")
  end

  def google_oauth2
    handle_oauth("google_oauth2")
  end

  def failure
    redirect_to backoffice_login_path, alert: "Authentication failed. Please try again."
  end

  private

  def handle_oauth(provider)
    auth  = request.env["omniauth.auth"]
    email = auth.info.email.to_s.downcase.presence

    user = User.find_by(provider: provider, uid: auth.uid.to_s)
    user ||= User.find_by(email: email) if email

    if user
      user.update_columns(provider: provider, uid: auth.uid.to_s) if user.uid.blank?
      login_user(user)
    else
      session[:oauth_data] = {
        "provider" => provider,
        "uid"      => auth.uid.to_s,
        "name"     => auth.info.name.to_s,
        "email"    => email
      }
      redirect_to backoffice_register_path,
        notice: "One last step — choose your account type to finish signing up."
    end
  end

  def login_user(user)
    if user.webauthn_credentials.any?
      session[:pending_webauthn_user_id] = user.id
      redirect_to backoffice_webauthn_verify_path
    elsif user.otp_enabled?
      session[:pending_2fa_user_id] = user.id
      redirect_to backoffice_two_factor_verify_path
    else
      session[:user_id] = user.id
      dest = user.nomad? ? backoffice_root_path : backoffice_messages_path
      redirect_to dest, notice: "Welcome back, #{user.name}!"
    end
  end
end
