module Backoffice
  class SessionsController < ApplicationController
    layout "backoffice"

    def new
      redirect_to backoffice_root_path if current_user
    end

    def create
      user = User.find_by(email: params[:email].to_s.downcase)
      if user&.authenticate(params[:password])
        session[:user_id] = user.id
        dest = user.nomad? ? backoffice_root_path : backoffice_messages_path
        redirect_to dest, notice: "Welcome back, #{user.name}!"
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
