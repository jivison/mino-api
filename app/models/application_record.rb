class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.group_by(column)
    self.all.inject({}) do |acc, entity| 
      acc[entity.send(column)] ||= []
      acc[entity.send(column)] << entity
      acc
    end
  end

  def self.sample
    self.all.sample
  end

  def self.sort_by(column_name)
    self.all.sort_by { |entity| entity.send(column_name) }
  end

end
