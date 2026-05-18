class Backoffice::Forums::PostsController < Backoffice::BaseController
  def create
    @forum = Forum.find(params[:forum_id])
    @post  = @forum.forum_posts.build(post_params.merge(user: current_user))

    if @post.save
      redirect_to backoffice_forum_path(@forum, anchor: "post-#{@post.id}"),
                  notice: "Reply posted"
    else
      redirect_to backoffice_forum_path(@forum), alert: @post.errors.full_messages.to_sentence
    end
  end

  def destroy
    @forum = Forum.find(params[:forum_id])
    @post  = current_user.forum_posts.find(params[:id])
    @post.destroy
    redirect_to backoffice_forum_path(@forum), notice: "Reply deleted"
  end

  private

  def post_params
    params.require(:forum_post).permit(:body)
  end
end
