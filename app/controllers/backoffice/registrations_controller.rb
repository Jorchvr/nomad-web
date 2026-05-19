module Backoffice
  class RegistrationsController < ApplicationController
    layout "backoffice"

    def new
      redirect_to backoffice_root_path if current_user
      @oauth_data = session[:oauth_data]
      if params[:role].in?(%w[nomad client])
        @role = params[:role]
        @user = User.new(role: @role, name: @oauth_data&.dig("name"), email: @oauth_data&.dig("email"))
      else
        render :pick_role and return
      end
    end

    def create
      @oauth_data = session[:oauth_data]
      @user = User.new(user_params)

      if @oauth_data
        @user.provider           = @oauth_data["provider"]
        @user.uid                = @oauth_data["uid"]
        @user.email_confirmed    = true
        @user.password           = SecureRandom.hex(24)
        @user.password_confirmation = @user.password
      end

      @role = @user.role
      if @user.save
        session.delete(:oauth_data)
        unless @oauth_data
          @user.generate_confirmation_token!
          UserMailer.confirmation_email(@user).deliver_now
        end
        session[:user_id] = @user.id
        if @user.nomad?
          redirect_to edit_backoffice_profile_path,
            notice: "Account created! Welcome to World Nomad Web."
        else
          redirect_to backoffice_messages_path,
            notice: "Account created! Welcome to World Nomad Web."
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
