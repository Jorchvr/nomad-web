module Backoffice
  class SessionsController < ApplicationController
    layout "backoffice"

    def new
      redirect_to backoffice_root_path if current_user
    end

    def create
      user = User.find_by(email: params[:email].to_s.downcase)
      if user&.authenticate(params[:password])
        if user.webauthn_credentials.any?
          session[:pending_webauthn_user_id] = user.id
          redirect_to backoffice_webauthn_verify_path
        elsif user.otp_enabled? && !user.admin?
          session[:pending_2fa_user_id] = user.id
          redirect_to backoffice_two_factor_verify_path
        elsif user.admin?
          session[:user_id] = user.id
          redirect_to backoffice_two_factor_setup_path,
            alert: "Admin accounts require two-factor authentication. Please set it up now."
        else
          session[:user_id] = user.id
          dest = user.nomad? ? backoffice_root_path : backoffice_messages_path
          redirect_to dest, notice: "Welcome back, #{user.name}!"
        end
      else
        flash.now[:alert] = "Incorrect email or password."
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      session.delete(:user_id)
      redirect_to backoffice_login_path, notice: "You have been signed out."
    end
  end
end
