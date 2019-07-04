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

  paginates_per 10
  max_paginates_per 100

  class << self
    def get(filter)
      # Si no hay ningún filtro o los parámetros tienen valores nulos se devuelven todos
      if filter.nil? || empty(filter)
        Post.all
      else
        Post.where(construct_criteria(filter))
      end
    end

    def order(posts, sort)
      if sort.nil?
        posts
      else
        @order_criteria = ''

        array = sort.split(',')

        array.each do |item|
          @order_criteria = if @order_criteria.empty?
                              order_criteria(item)
                            else
                              "#{@order_criteria}, #{order_criteria(item)}"
                            end
        end

        posts.includes(:user).order(@order_criteria)
      end
    end

    def paginate(posts, page)
      @number = page[:number] unless page.nil?
      @size = page[:size] unless page.nil?
      posts.page(@number).per(@size)
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

    def order_criteria(item)
      @criteria = ''
      @criteria = 'title' if item.include? 'title'
      @criteria = 'created_at' if item.include? 'created_at'
      @criteria = 'users.name' if item.include? 'author'

      @criteria = if item[0] == '-'
                    @criteria + ' DESC'
                  else
                    @criteria + ' ASC'
                  end
    end
  end
end
