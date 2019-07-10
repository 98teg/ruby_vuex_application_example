class Comment < ApplicationRecord
  include AsJsonRepresentations

  belongs_to :user
  belongs_to :post

  validates :user_id, presence: true
  validates :post_id, presence: true
  validates :content, presence: true

  representation :basic do
    {
      content: content,
      creation: created_at,
      post_id: post_id,
      user_id: user_id,
      id: id
    }
  end

  paginates_per 10
  max_paginates_per 100

  class << self
    def get(filter)
      # Si no hay ningún filtro o los parámetros tienen valores nulos se devuelven todos
      if filter.nil? || empty(filter)
        Comment.all
      else
        Comment.where(construct_criteria(filter))
      end
    end

    def order(comments, sort)
      if sort.nil?
        comments
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

        comments.includes(:user, :post).order(@order_criteria)
      end
    end

    def paginate(comments, page)
      @number = page[:number] unless page.nil?
      @size = page[:size] unless page.nil?
      comments.page(@number).per(@size)
    end

    private

    def empty(filter)
      filter[:content].nil? && filter[:since].nil? && filter[:until].nil? &&
        filter[:user_id].nil? && filter[:post_id].nil?
    end

    def construct_criteria(filter)
      @first_criteria = true

      unless filter[:content].nil?
        @criteria = add_criteria("content LIKE '%#{filter[:content]}%'")
        @first_criteria = false
      end

      unless filter[:since].nil?
        @criteria = add_criteria("created_at > '#{filter[:since]}'")
        @first_criteria = false
      end

      unless filter[:until].nil?
        @criteria = add_criteria("created_at < '#{filter[:until]}'")
        @first_criteria = false
      end

      unless filter[:user_id].nil?
        @criteria = add_criteria("user_id = '#{filter[:user_id]}'")
        @first_criteria = false
      end

      unless filter[:post_id].nil?
        @criteria = add_criteria("post_id = '#{filter[:post_id]}'")
        @first_criteria = false
      end

      @criteria
    end

    def add_criteria(condition)
      if @first_criteria
        condition
      else
        "#{@criteria} and #{condition}"
      end
    end

    def order_criteria(item)
      @criteria = ''
      @criteria = 'created_at' if item.include? 'created_at'
      @criteria = 'users.name' if item.include? 'user_name'
      @criteria = 'posts.title' if item.include? 'post_title'

      @criteria = if item[0] == '-'
                    @criteria + ' DESC'
                  else
                    @criteria + ' ASC'
                  end
    end
  end
end
