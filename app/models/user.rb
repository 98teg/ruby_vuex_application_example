class User < ApplicationRecord
  include AsJsonRepresentations

  has_many :posts, dependent: :destroy

  validates :name, presence: true, length: {maximum: 63}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: true

  representation :basic do
    {
      name: name,
      email: email,
      creation: created_at
    }
  end
end
