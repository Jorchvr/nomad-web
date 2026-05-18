class Backoffice::FriendshipsController < Backoffice::BaseController
  before_action :require_nomad!

  def index
    @friends          = current_user.friends
    @pending_received = current_user.pending_friend_requests
    @pending_sent     = current_user.sent_friendships.pending.includes(:receiver)
  end

  def create
    receiver = User.find(params[:receiver_id])
    friendship = current_user.sent_friendships.build(receiver: receiver)

    if friendship.save
      redirect_back fallback_location: backoffice_members_path,
                    notice: "Friend request sent to #{receiver.name}"
    else
      redirect_back fallback_location: backoffice_members_path,
                    alert: friendship.errors.full_messages.to_sentence
    end
  end

  def update
    friendship = current_user.received_friendships.find(params[:id])
    friendship.update!(status: "accepted")
    redirect_to backoffice_friendships_path, notice: "You are now friends with #{friendship.sender.name}"
  end

  def destroy
    friendship = Friendship.where(sender: current_user)
                           .or(Friendship.where(receiver: current_user))
                           .find(params[:id])
    other = friendship.sender == current_user ? friendship.receiver : friendship.sender
    friendship.destroy
    redirect_to backoffice_friendships_path, notice: "Request removed"
  end
end
