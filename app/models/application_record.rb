class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Disable postgres logging
  ActiveRecord::Base.logger.level = 1

  def self.sample
    self.all.sample
  end

end
