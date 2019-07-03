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

  class << self
    def get(filter)
      # Si no hay ningún filtro o los parámetros tienen valores nulos se devuelven todos
      if filter.nil? || (filter[:name].nil? && filter[:email].nil?)
        User.all
      else
        User.where(construct_criteria(filter))
      end
    end

    def order(users, sort)
      if sort.nil?
        users
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

        users.order(@order_criteria)
      end
    end

    private

    def construct_criteria(filter)
      @first_criteria = true

      unless filter[:name].nil?
        @criteria = "name LIKE '%#{filter[:name]}%'"
        @first_criteria = false
      end

      unless filter[:email].nil?
        @criteria = if @first_criteria
                      "email = '#{filter[:email]}'"
                    else
                      "#{@criteria} and email = '#{filter[:email]}'"
                    end
      end

      @criteria
    end

    def order_criteria(item)
      if item == 'name'
        'name ASC'
      elsif item == '-name'
        'name DESC'
      elsif item == 'email'
        'email ASC'
      elsif item == '-email'
        'email DESC'
      end
    end
  end
end
