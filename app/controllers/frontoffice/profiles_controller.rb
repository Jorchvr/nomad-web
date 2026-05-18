module Frontoffice
  class ProfilesController < BaseController
    def index
      @map_profiles = User.published.includes(avatar_attachment: :blob)
      @profiles = @map_profiles.order(created_at: :desc)
      @profiles = @profiles.search(params[:q]) if params[:q].present?
      @profiles = @profiles.by_country(params[:country]) if params[:country].present?
      @countries = User.published.distinct.pluck(:country).sort
    end

    def show
      @profile = User.published
                     .includes(:profile_links, work_photos: { image_attachment: :blob },
                               avatar_attachment: :blob)
                     .find(params[:id])
    end

    def portfolio
      @profile = User.published
                     .includes(avatar_attachment: :blob,
                               work_photos: { image_attachment: :blob })
                     .find(params[:id])
      @photos = @profile.work_photos.includes(image_attachment: :blob).order(created_at: :desc)
    end
  end
end
