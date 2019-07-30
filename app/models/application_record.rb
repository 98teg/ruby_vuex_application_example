class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.filter(filters={})
    return all if filters.blank?

    query = all
    filters.each do |key, value|
      query = query.send("#{key}_filter", value) unless value.nil?
    end

    query
  end

  def self.ordenate(sort={})
    return all if sort.blank?

    query = all
    sort = sort.split(',')
    sort.each do |key|
      next if key.nil?

      query = if key[0] == '-'
                key[0] = ''
                query.send("#{key}_sort", 'DESC')
              else
                query.send("#{key}_sort", 'ASC')
              end
    end

    query
  end

  def self.paginate(page={})
    page = {} if page.nil?

    number = page[:number]
    size = page[:size]

    all.page(number).per(size)
  end
end
