class Backoffice::TravelStoriesController < Backoffice::BaseController
  before_action :require_nomad!
  before_action :set_story, only: [:show, :edit, :update, :destroy]

  def index
    @stories = current_user.travel_stories.recent
  end

  def show; end

  def new
    @story = current_user.travel_stories.build
  end

  def create
    @story = current_user.travel_stories.build(story_params)
    if @story.save
      redirect_to backoffice_travel_stories_path, notice: "Story published!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @story.update(story_params)
      redirect_to backoffice_travel_stories_path, notice: "Story updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @story.photos.purge
    @story.destroy
    redirect_to backoffice_travel_stories_path, notice: "Story deleted."
  end

  private

  def set_story
    @story = current_user.travel_stories.find(params[:id])
  end

  def story_params
    params.require(:travel_story).permit(
      :title, :description, :location, :country,
      :client_name, :visited_at, :published,
      photos: []
    )
  end
end
