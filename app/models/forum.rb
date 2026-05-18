class Forum < ApplicationRecord
  belongs_to :user
  has_many :forum_posts, dependent: :destroy

  validates :title, presence: true, length: { maximum: 150 }
  validates :body,  length: { maximum: 5000 }

  scope :recent, -> { order(created_at: :desc) }
end
