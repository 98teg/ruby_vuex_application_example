class Post < ApplicationRecord
  include AsJsonRepresentations

  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true

  representation :basic do
    {
      title: title,
      content: content,
      creation: created_at,
      author: user_id
    }
  end
end
