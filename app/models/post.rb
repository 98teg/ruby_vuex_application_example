class Post < ApplicationRecord
  include AsJsonRepresentations

  require 'carrierwave/orm/activerecord'
  mount_uploader :image, PostImageUploader

  belongs_to :user
  has_many :comments, dependent: :destroy
  validates :user_id, presence: true
  validates :title, presence: true
  validates :content, presence: true

  representation :basic do
    {
      title: title,
      content: content,
      image: image,
      creation: created_at,
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
        filter[:since].nil? && filter[:until].nil? && filter[:user_id].nil?
    end

    def construct_criteria(filter)
      @first_criteria = true

      unless filter[:title].nil?
        @criteria = "title LIKE '%#{filter[:title].clone.gsub("'", "''")}%'"
        @first_criteria = false
      end

      unless filter[:content].nil?
        @criteria = add_criteria("content LIKE '%#{filter[:content].clone.gsub("'", "''")}%'")
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
      @criteria = 'title' if item.include? 'title'
      @criteria = 'created_at' if item.include? 'created_at'
      @criteria = 'users.name' if item.include? 'user_name'

      @criteria = if item[0] == '-'
                    @criteria + ' DESC'
                  else
                    @criteria + ' ASC'
                  end
    end
  end
end
