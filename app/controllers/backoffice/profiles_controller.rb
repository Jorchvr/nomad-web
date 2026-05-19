module Backoffice
  class ProfilesController < BaseController
    before_action :require_nomad!

    def show
      @user = current_user
    end

    def edit
      @user = current_user
    end

    def update
      @user = current_user
      if @user.update(profile_params)
        redirect_to backoffice_profile_path, notice: "Profile updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy_avatar
      current_user.avatar.purge
      redirect_to edit_backoffice_profile_path, notice: "Profile photo deleted"
    end

    private

    def profile_params
      params.require(:user).permit(:name, :country, :city, :latitude, :longitude,
                                   :profession, :bio, :whatsapp, :published, :avatar)
    end
  end
end
