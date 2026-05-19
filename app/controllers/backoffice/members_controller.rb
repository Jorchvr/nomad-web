class Backoffice::MembersController < Backoffice::BaseController
  before_action :require_nomad!
  before_action :set_member, only: [:show, :verify]

  def index
    @members = if current_user.admin?
                 User.where.not(id: current_user.id)
               else
                 User.where(role: "nomad").where.not(id: current_user.id)
               end
    @members = @members.order(:name)
    @members = @members.search(params[:q]) if params[:q].present?
  end

  def show
    @friendship    = current_user.friendship_with(@member)
    @mutual_friends = current_user.friends & @member.friends
  end

  def verify
    require_admin!
    @member.update!(verified: !@member.verified)
    status = @member.verified? ? "verified" : "unverified"
    redirect_to backoffice_member_path(@member), notice: "#{@member.name} marked as #{status}."
  end

  private

  def set_member
    @member = User.find(params[:id])
  end
end
