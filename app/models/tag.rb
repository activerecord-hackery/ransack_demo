class Tag < ApplicationRecord
  has_many :taggings

  def self.ransackable_attributes(_auth_object = nil)
    ["name"]
  end
end
