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

  def self.get(filter)
    # Si no hay ningún filtro o los parámetros tienen valores nulos se devuelven todos
    if filter.nil? || (filter[:title].nil? && filter[:content].nil?)
      Post.all
    # Si solo tenemos el título, se devuelven aquellos posts cuyo título lo incluya
    elsif filter[:content].nil?
      Post.where('title LIKE ?', "%#{filter[:title]}%")
    # Si solo tenemos el contenido, se devuelven aquellos cuyo contenido lo incluya
    elsif filter[:title].nil?
      Post.where('content LIKE ?', "%#{filter[:content]}%")
    # Si tenemos ambos, aplicamos los dos criterios anteriores
    else
      Post.where('title LIKE ? and content LIKE ?', "%#{filter[:title]}%", "%#{filter[:content]}%")
    end
  end
end
