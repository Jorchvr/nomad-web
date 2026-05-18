class Backoffice::WorkPhotosController < Backoffice::BaseController
  before_action :require_nomad!

  def index
    @photos = current_user.work_photos.includes(image_attachment: :blob).order(created_at: :desc)
    @photo  = WorkPhoto.new
  end

  def create
    @photo = current_user.work_photos.build(photo_params)
    if @photo.save
      redirect_to backoffice_work_photos_path, notice: "Photo uploaded"
    else
      @photos = current_user.work_photos.includes(image_attachment: :blob).order(created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @photo = current_user.work_photos.find(params[:id])
    @photo.destroy
    redirect_to backoffice_work_photos_path, notice: "Photo deleted"
  end

  private

  def photo_params
    params.require(:work_photo).permit(:image, :caption)
  end
end
