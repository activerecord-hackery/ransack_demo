class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :taggings, as: :taggable
  has_many :tags, through: :taggings

  validates_presence_of :user

  def tag_names=(names)
    self.tags = names.split(/,\s*/).map do |name|
      Tag.find_or_create_by_name(name)
    end
  end

  def tag_names
    tags.join(', ')
  end
end
