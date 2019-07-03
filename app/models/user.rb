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
      elsif sort.include? '-name'
        users.sort_by(&:name).reverse
      elsif sort.include? 'name'
        users.sort_by(&:name)
      elsif sort.include? '-email'
        users.sort_by(&:email).reverse
      elsif sort.include? 'email'
        users.sort_by(&:email)
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
  end
end
