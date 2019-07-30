class User < ApplicationRecord
  rolify
  include AsJsonRepresentations
  include RailsJwtAuth::Authenticatable
  include RailsJwtAuth::Confirmable

  after_create :assign_default_role

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :name, presence: true, length: {maximum: 64}
  validates :email, presence: true,
                    uniqueness: true,
                    format: URI::MailTo::EMAIL_REGEXP

  scope :name_filter, ->(name) { where("name LIKE '%#{name.gsub("'", "''")}%'") }
  scope :email_filter, ->(email) { where("email = '#{email.gsub("'", "''")}'") }

  scope :name_sort, ->(order_criteria) { order('name ' + order_criteria) }
  scope :email_sort, ->(order_criteria) { order('email ' + order_criteria) }

  def assign_default_role
    add_role(:user) if roles.blank?
  end

  def to_token_payload(_request)
    {
      auth_token: regenerate_auth_token,
      user_id: id
    }
  end

  representation :basic do
    {
      name: name,
      email: email,
      id: id,
      creation: created_at,
      role: roles_name
    }
  end
end
