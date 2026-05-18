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
  end
end
