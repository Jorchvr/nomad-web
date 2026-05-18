module Frontoffice
  class TravelStoriesController < BaseController
    def index
      @stories = TravelStory.published.recent
                            .includes(:user, photos_attachments: :blob)
      @countries = TravelStory.published.distinct.pluck(:country).compact.sort
      @stories = @stories.where(country: params[:country]) if params[:country].present?
    end

    def show
      @story = TravelStory.published
                          .includes(:user, photos_attachments: :blob)
                          .find(params[:id])
    end
  end
end
