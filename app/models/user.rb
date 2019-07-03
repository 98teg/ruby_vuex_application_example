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

  def self.get(filter)
    # Si no hay ningún filtro o los parámetros tienen valores nulos se devuelven todos
    if filter.nil? || (filter[:name].nil? && filter[:email].nil?)
      User.all
    # Si solo tenemos el nombre, se devuelven aquellos usuarios cuyo nombre lo incluya
    elsif filter[:email].nil?
      User.where('name LIKE ?', "%#{filter[:name]}%")
    # Si solo tenemos el correo, se devuelven aquellos cuyo correo coincida completamente
    elsif filter[:name].nil?
      User.find_by email: filter[:email]
    # Si tenemos ambos, aplicamos los dos criterios anteriores
    else
      User.where('name LIKE ? and email = ?', "%#{filter[:name]}%", filter[:email])
    end
  end
end
