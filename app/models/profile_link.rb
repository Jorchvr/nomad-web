class ProfileLink < ApplicationRecord
  belongs_to :user

  validates :label, presence: true, length: { maximum: 60 }
  validates :url,   presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "must be a valid URL" }
end
