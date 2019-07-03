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

  class << self
    def get(filter)
      # Si no hay ningún filtro o los parámetros tienen valores nulos se devuelven todos
      if filter.nil? || empty(filter)
        Post.all
      else
        Post.where(construct_criteria(filter))
      end
    end

    private

    def empty(filter)
      filter[:title].nil? && filter[:content].nil? &&
        filter[:since].nil? && filter[:until].nil? && filter[:author].nil?
    end

    def construct_criteria(filter)
      @first_criteria = true

      unless filter[:title].nil?
        @criteria = "title LIKE '%#{filter[:title]}%'"
        @first_criteria = false
      end

      unless filter[:content].nil?
        @criteria = add_criteria(@criteria, @first_criteria,
                                 "content LIKE '%#{filter[:content]}%'")
        @first_criteria = false
      end

      unless filter[:since].nil?
        @criteria = add_criteria(@criteria, @first_criteria,
                                 "created_at > '#{filter[:since]}'")
        @first_criteria = false
      end

      unless filter[:until].nil?
        @criteria = add_criteria(@criteria, @first_criteria,
                                 "created_at < '#{filter[:until]}'")
        @first_criteria = false
      end

      unless filter[:author].nil?
        @criteria = add_criteria(@criteria, @first_criteria,
                                 "user_id = '#{filter[:author]}'")
        @first_criteria = false
      end

      @criteria
    end

    def add_criteria(criteria, first_criteria, condition)
      if first_criteria
        condition
      else
        "#{criteria} and #{condition}"
      end
    end
  end
end
