class Post < ApplicationRecord
  extend PostsMixin

  belongs_to :user
  has_many :comments
  has_many :taggings, as: :taggable
  has_many :tags, through: :taggings

  validates_presence_of :user

  ransacker :title_diddly do |parent|
    Arel::Nodes::InfixOperation.new("||", parent.table[:title], "-diddly")
  end

  def tag_names=(names)
    self.tags = names.split(/,\s*/).map do |name|
      Tag.find_or_create_by(name: name)
    end
  end

  def tag_names
    tags.join(", ")
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["title"]
  end

  def self.ransackable_associations(_auth_object = nil)
    ["tags"]
  end
end
