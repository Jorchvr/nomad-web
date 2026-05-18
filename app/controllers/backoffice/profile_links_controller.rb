class Backoffice::ProfileLinksController < Backoffice::BaseController
  before_action :require_nomad!

  def create
    @link = current_user.profile_links.build(link_params)
    if @link.save
      redirect_to edit_backoffice_profile_path, notice: "Link added"
    else
      redirect_to edit_backoffice_profile_path,
                  alert: @link.errors.full_messages.to_sentence
    end
  end

  def destroy
    @link = current_user.profile_links.find(params[:id])
    @link.destroy
    redirect_to edit_backoffice_profile_path, notice: "Link deleted"
  end

  private

  def link_params
    params.require(:profile_link).permit(:label, :url)
  end
end
