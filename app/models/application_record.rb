class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Disable postgres logging
  ActiveRecord::Base.logger.level = 1

  def self.group_by(column)
    # returns:
    # {
    #   column_value1: [entity1, entity3],
    #   column_value2: [entity2]
    # }
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
