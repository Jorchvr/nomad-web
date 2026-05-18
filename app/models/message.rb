class Message < ApplicationRecord
  belongs_to :sender,   class_name: "User"
  belongs_to :receiver, class_name: "User"

  validates :body, presence: true

  scope :between, ->(a, b) {
    where(
      "(sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)",
      a.id, b.id, b.id, a.id
    ).order(created_at: :asc)
  }

  scope :unread_for, ->(user) {
    where(receiver_id: user.id, read_at: nil)
  }
end
