class Backoffice::ForumsController < Backoffice::BaseController
  before_action :require_nomad!

  def index
    @forums = Forum.includes(:user, :forum_posts).recent
  end

  def show
    @forum = Forum.find(params[:id])
    @posts = @forum.forum_posts.chronological.includes(:user)
    @new_post = ForumPost.new
  end

  def new
    @forum = Forum.new
  end

  def create
    @forum = current_user.forums.build(forum_params)
    if @forum.save
      redirect_to backoffice_forum_path(@forum), notice: "Forum created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @forum = current_user.forums.find(params[:id])
    @forum.destroy
    redirect_to backoffice_forums_path, notice: "Forum deleted"
  end

  private

  def forum_params
    params.require(:forum).permit(:title, :body)
  end
end
