module Backoffice
  class ConfirmationsController < ApplicationController
    layout "backoffice"

    def show
      user = User.find_by(confirmation_token: params[:token])
      if user
        user.confirm_email!
        session[:user_id] = user.id
        redirect_to backoffice_root_path, notice: "Email confirmed! Welcome to World Nomad Web."
      else
        redirect_to backoffice_login_path, alert: "Invalid or expired confirmation link."
      end
    end

    def resend
      user = current_user
      unless user
        redirect_to backoffice_login_path and return
      end

      if user.email_confirmed?
        redirect_to backoffice_root_path, notice: "Your email is already confirmed."
        return
      end

      user.generate_confirmation_token!
      UserMailer.confirmation_email(user).deliver_now
      redirect_to backoffice_root_path, notice: "Confirmation email sent to #{user.email}. Check your inbox and spam folder."
    rescue => e
      redirect_to backoffice_root_path, alert: "Could not send email: #{e.message}"
    end

    private

    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
end
