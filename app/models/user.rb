class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_and_belongs_to_many :roles

  def created
    created_at.to_s(:long)
  end

  def updated
    updated_at.to_s(:long)
  end

  ransacker :full_name do |parent|
    Arel::Nodes::InfixOperation.new('||',
      Arel::Nodes::InfixOperation.new('||',
        parent.table[:first_name], Arel::Nodes.build_quoted(' ')),
      parent.table[:last_name])
  end
end
