module Backoffice
  class RegistrationsController < ApplicationController
    layout "backoffice"

    def new
      redirect_to backoffice_root_path if current_user
      if params[:role].in?(%w[nomad client])
        @role = params[:role]
        @user = User.new(role: @role)
      else
        render :pick_role and return
      end
    end

    def create
      @user = User.new(user_params)
      @role = @user.role
      if @user.save
        session[:user_id] = @user.id
        if @user.nomad?
          redirect_to edit_backoffice_profile_path,
            notice: "Account created! Complete your profile to appear in the directory."
        else
          redirect_to backoffice_messages_path,
            notice: "Account created! Browse the directory and send messages to nomads."
        end
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation,
                                   :country, :profession, :bio, :role)
    end
  end
end
