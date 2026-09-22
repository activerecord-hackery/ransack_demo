class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates_presence_of :user, :post

  def self.ransackable_attributes(_auth_object = nil)
    ["body"]
  end
end
