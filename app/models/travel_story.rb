class TravelStory < ApplicationRecord
  belongs_to :user
  has_many_attached :photos

  validates :title,       presence: true, length: { maximum: 120 }
  validates :description, presence: true
  validates :location,    presence: true
  validates :visited_at,  presence: true

  validate :acceptable_photos

  scope :published, -> { where(published: true) }
  scope :recent,    -> { order(visited_at: :desc) }

  private

  def acceptable_photos
    photos.each do |photo|
      unless photo.blob.byte_size <= 8.megabytes
        errors.add(:photos, "each photo must be smaller than 8 MB")
      end
      unless photo.blob.content_type.start_with?("image/")
        errors.add(:photos, "only image files are allowed")
      end
    end
  end
end
