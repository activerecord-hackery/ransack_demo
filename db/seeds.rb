# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'machinist/active_record'

role = {}
role[:admin] = Role.create :name => 'admin', :description => 'Superuser.'
role[:moderator] = Role.create :name => 'moderator', :description => 'Can moderate comments.'
role[:user] = Role.create :name => 'user', :description => 'A plain old user.'

# User shams
Sham.define do
  first_name { Faker::Name.first_name }
  last_name  { Faker::Name.last_name }
  role       { |index| (index % 2).zero? ? role[:moderator] : role[:user] }
end

User.blueprint do
  first_name
  last_name
  roles       { [Sham.role] }
  email       { "#{object.first_name.downcase}-#{object.last_name.downcase}@example.com" }
end

commenters = 1.upto(3).map { User.make :roles => [role[:user]] }

# Post/comment shams
Sham.define do
  title                        { Faker::Lorem.sentence }
  body                         { Faker::Lorem.paragraph }
  commenter(:unique => false)  { |index| commenters[index % 3] }
end

Comment.blueprint do
  user { Sham.commenter }
  body
end

Post.blueprint do
  title
  body
  tag_names   { Faker::Lorem.words(3).join(',') }
end

10.times do
  User.make(:roles => [role[:admin]]) do |user|
    3.times do
      user.posts.make do |post|
        3.times { post.comments.make }
      end
    end
  end
end