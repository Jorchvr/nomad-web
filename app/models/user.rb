class User < ApplicationRecord
  has_secure_password

  has_one_attached :avatar

  has_many :sent_friendships,     class_name: "Friendship", foreign_key: :sender_id,   dependent: :destroy
  has_many :received_friendships, class_name: "Friendship", foreign_key: :receiver_id, dependent: :destroy
  has_many :forums,       dependent: :destroy
  has_many :forum_posts,  dependent: :destroy
  has_many :profile_links, dependent: :destroy
  has_many :work_photos,     dependent: :destroy
  has_many :travel_stories,   dependent: :destroy
  has_many :sent_messages,    class_name: "Message", foreign_key: :sender_id,   dependent: :destroy
  has_many :received_messages, class_name: "Message", foreign_key: :receiver_id, dependent: :destroy

  def friends
    accepted_sent     = sent_friendships.accepted.includes(:receiver).map(&:receiver)
    accepted_received = received_friendships.accepted.includes(:sender).map(&:sender)
    accepted_sent + accepted_received
  end

  def friendship_with(other_user)
    sent_friendships.find_by(receiver: other_user) ||
      received_friendships.find_by(sender: other_user)
  end

  def friend_of?(other_user)
    friendship = friendship_with(other_user)
    friendship&.accepted?
  end

  def pending_friend_requests
    received_friendships.pending.includes(:sender)
  end

  validates :role, inclusion: { in: %w[nomad client] }
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :country, :profession, presence: true, if: :nomad?

  def nomad?  = role == "nomad"
  def client? = role == "client"
  def admin?  = admin == true

  before_save { self.email = email.downcase }

  def generate_otp_secret!
    update_column(:otp_secret, ROTP::Base32.random)
  end

  def otp_provisioning_uri(issuer = "World Nomad Web")
    totp = ROTP::TOTP.new(otp_secret, issuer: issuer)
    totp.provisioning_uri(email)
  end

  def verify_otp(code)
    return false if otp_secret.blank?
    totp = ROTP::TOTP.new(otp_secret)
    totp.verify(code.to_s.strip, drift_behind: 30, drift_ahead: 30)
  end

  def generate_confirmation_token!
    self.confirmation_token = SecureRandom.urlsafe_base64(32)
    save!(validate: false)
  end

  def confirm_email!
    update_columns(email_confirmed: true, confirmation_token: nil)
  end

  scope :published, -> { where(published: true) }
  scope :by_country, ->(country) { where(country: country) }
  scope :search, ->(q) {
    where(
      "name LIKE :q OR profession LIKE :q OR country LIKE :q OR bio LIKE :q",
      q: "%#{sanitize_sql_like(q)}%"
    )
  }

  def gravatar_url(size = 200)
    hash = Digest::MD5.hexdigest(email.downcase.strip)
    "https://www.gravatar.com/avatar/#{hash}?s=#{size}&d=identicon"
  end

  def whatsapp_url
    return nil if whatsapp.blank?
    "https://wa.me/#{whatsapp.gsub(/\D/, '')}"
  end

  def initials
    name.split.first(2).map { |n| n[0].upcase }.join
  end
end
