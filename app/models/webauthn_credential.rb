class WebauthnCredential < ApplicationRecord
  belongs_to :user

  validates :external_id, :public_key, presence: true, uniqueness: true
  validates :nickname, presence: true
  validates :sign_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
