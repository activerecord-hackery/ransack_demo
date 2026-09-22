class Role < ApplicationRecord
  has_and_belongs_to_many :users

  def self.ransackable_attributes(_auth_object = nil)
    ["name"]
  end
end
