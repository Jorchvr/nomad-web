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
        @user.generate_confirmation_token!
        UserMailer.confirmation_email(@user).deliver_later
        session[:user_id] = @user.id
        if @user.nomad?
          redirect_to edit_backoffice_profile_path,
            notice: "Account created! Check your email to confirm your address."
        else
          redirect_to backoffice_messages_path,
            notice: "Account created! Check your email to confirm your address."
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
