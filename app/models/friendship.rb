class Friendship < ApplicationRecord
  belongs_to :sender,   class_name: "User"
  belongs_to :receiver, class_name: "User"

  validates :status, inclusion: { in: %w[pending accepted] }
  validate :no_self_friendship
  validate :not_duplicate, on: :create

  scope :pending,  -> { where(status: "pending") }
  scope :accepted, -> { where(status: "accepted") }

  def accepted?  = status == "accepted"
  def pending?   = status == "pending"

  private

  def no_self_friendship
    errors.add(:receiver, "you cannot add yourself as a friend") if sender_id == receiver_id
  end

  def not_duplicate
    exists = Friendship.where(sender_id: sender_id, receiver_id: receiver_id)
                       .or(Friendship.where(sender_id: receiver_id, receiver_id: sender_id))
                       .exists?
    errors.add(:base, "a request already exists between these users") if exists
  end
end
