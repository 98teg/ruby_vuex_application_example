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

  def self.get(filter)
    if filter.nil? || (filter[:name].nil? && filter[:email].nil?)
      User.all
    elsif filter[:email].nil?
      User.where('name LIKE ?', "%#{filter[:name]}%")
    elsif filter[:name].nil?
      User.find_by email: filter[:email]
    else
      User.where('name LIKE ? and email = ?', "%#{filter[:name]}%", filter[:email])
    end
  end
end
