class Base < ActiveRecord::Base
  include RansackableAttributes

  if Kaminari.config.page_method_name != :page
    def self.page num
      send Kaminari.config.page_method_name, num
    end
  end

  self.abstract_class = true

  def self.spree_base_scopes
    where(nil)
  end
end
