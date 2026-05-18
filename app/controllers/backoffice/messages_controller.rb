class Backoffice::MessagesController < Backoffice::BaseController
  def index
    all_msg = Message.where("sender_id = :id OR receiver_id = :id", id: current_user.id)

    partner_ids = all_msg.pluck(:sender_id, :receiver_id)
                         .flatten.uniq - [current_user.id]

    partners = User.where(id: partner_ids).index_by(&:id)

    @conversations = partner_ids.filter_map do |pid|
      partner = partners[pid]
      next unless partner
      last_msg = Message.between(current_user, partner).last
      unread   = Message.where(sender_id: pid, receiver_id: current_user.id, read_at: nil).count
      { user: partner, last_message: last_msg, unread: unread }
    end.sort_by { |c| -c[:last_message].created_at.to_i }

    @unread_total = Message.unread_for(current_user).count
  end

  def show
    @other = User.find(params[:user_id])
    @messages = Message.between(current_user, @other)
    Message.where(sender_id: @other.id, receiver_id: current_user.id, read_at: nil)
           .update_all(read_at: Time.current)
    @new_message = Message.new
  end

  def create
    @other = User.find(message_params[:receiver_id])
    msg = current_user.sent_messages.build(
      receiver_id: @other.id,
      body: message_params[:body]
    )
    if msg.save
      redirect_to backoffice_message_conversation_path(@other.id)
    else
      redirect_to backoffice_message_conversation_path(@other.id), alert: "Message cannot be blank."
    end
  end

  private

  def message_params
    params.require(:message).permit(:receiver_id, :body)
  end
end
