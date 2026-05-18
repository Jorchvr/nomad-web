class Backoffice::MembersController < Backoffice::BaseController
  before_action :require_nomad!

  def index
    @members = User.where.not(id: current_user.id).order(:name)
    @members = @members.search(params[:q]) if params[:q].present?
  end

  def show
    @member = User.find(params[:id])
    @friendship = current_user.friendship_with(@member)
    @mutual_friends = current_user.friends & @member.friends
  end
end
