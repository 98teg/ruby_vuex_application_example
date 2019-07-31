class Comment < ApplicationRecord
  include AsJsonRepresentations

  after_save :send_mails

  belongs_to :user
  belongs_to :post

  validates :user_id, presence: true
  validates :post_id, presence: true
  validates :content, presence: true

  scope :content_filter, ->(content) { where("content LIKE '%#{content.gsub("'", "''")}%'") }
  scope :since_filter, ->(date) { where("created_at > '#{date}'") }
  scope :until_filter, ->(date) { where("created_at < '#{date}'") }
  scope :user_id_filter, ->(id) { where("user_id = '#{id}'") }
  scope :post_id_filter, ->(id) { where("post_id = '#{id}'") }

  scope :created_at_sort, ->(order_criteria) { order('created_at ' + order_criteria) }
  scope :user_name_sort, lambda { |order_criteria|
    includes(:user).order('users.name ' + order_criteria)
  }
  scope :post_title_sort, lambda { |order_criteria|
    includes(:post).order('posts.title ' + order_criteria)
  }

  def send_mails
    CommentNotificationMailer.with(comment: @comment)
                             .send_notification.deliver_later
    CommentsCheckJob.perform_later @comment
  end

  representation :basic do
    {
      content: content,
      creation: created_at,
      post_id: post_id,
      user_id: user_id,
      author: User.find(user_id).name,
      id: id
    }
  end
end
