class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # def self.ransackable_attributes(auth_object = nil)
  #   unauthorized_ransackable_attributes
  # end

  def self.ransackable_associations(auth_object = nil)
    super # unauthorized_ransackable_associations
  end
end
