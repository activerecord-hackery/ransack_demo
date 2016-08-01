class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_and_belongs_to_many :roles

  def created
    created_at.to_s(:long_ordinal)
  end

  def updated
    updated_at.to_s(:long_ordinal)
  end

  ransacker :full_name do |parent|
    Arel::Nodes::InfixOperation.new('||',
      Arel::Nodes::InfixOperation.new('||', parent.table[:first_name], ' '),
      parent.table[:last_name])
  end
end
