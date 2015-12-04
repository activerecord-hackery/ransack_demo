class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_and_belongs_to_many :roles

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true

  ransacker :full_name do |parent|
    Arel::Nodes::InfixOperation.new('||',
      Arel::Nodes::InfixOperation.new('||', parent.table[:first_name], ' '),
      parent.table[:last_name])
  end
end
