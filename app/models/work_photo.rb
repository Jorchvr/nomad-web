class WorkPhoto < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :image, presence: true
  validates :caption, length: { maximum: 200 }

  validate :acceptable_image

  private

  def acceptable_image
    return unless image.attached?
    unless image.blob.byte_size <= 5.megabytes
      errors.add(:image, "must be smaller than 5 MB")
    end
    unless image.blob.content_type.start_with?("image/")
      errors.add(:image, "must be an image file (JPG, PNG, GIF, WebP)")
    end
  end
end
