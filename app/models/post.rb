class Post < ApplicationRecord
  include AsJsonRepresentations

  require 'carrierwave/orm/activerecord'
  mount_uploader :image, PostImageUploader

  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :user_id, presence: true
  validates :title, presence: true
  validates :content, presence: true

  scope :title_filter, ->(title) { where("title LIKE '%#{title.gsub("'", "''")}%'") }
  scope :content_filter, ->(content) { where("content LIKE '%#{content.gsub("'", "''")}%'") }
  scope :since_filter, ->(date) { where("created_at > '#{date}'") }
  scope :until_filter, ->(date) { where("created_at < '#{date}'") }
  scope :user_id_filter, ->(id) { where("user_id = '#{id}'") }

  scope :title_sort, ->(order_criteria) { order('title ' + order_criteria) }
  scope :created_at_sort, ->(order_criteria) { order('created_at ' + order_criteria) }
  scope :user_name_sort, lambda { |order_criteria|
    includes(:user).order('users.name ' + order_criteria)
  }

  representation :basic do
    {
      title: title,
      content: content,
      image: image,
      creation: created_at,
      user_id: user_id,
      author: User.find(user_id).name,
      id: id
    }
  end
end
