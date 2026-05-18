module ApplicationHelper
  def user_avatar_url(user, size = 200)
    user.avatar.attached? ? url_for(user.avatar) : user.gravatar_url(size)
  end
end
