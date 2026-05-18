class ForumPost < ApplicationRecord
  belongs_to :forum
  belongs_to :user

  validates :body, presence: true, length: { maximum: 5000 }

  scope :chronological, -> { order(created_at: :asc) }
end
