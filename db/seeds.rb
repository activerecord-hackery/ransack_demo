# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require "factory_girl"

role = {}

role[:admin] = Role.create(name: "admin", description: "Superuser.")

role[:moderator] = Role.create(
  name:        "moderator",
  description: "Can moderate comments."
  )

role[:user] = Role.create(name: "user", description: "A plain old user.")

FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name  }
    last_name  { Faker::Name.last_name }
    roles      { ["user"] }
    email      {
      "#{self.first_name.downcase}-#{self.last_name.downcase}@example.com"
    }
  end

  factory :post do
    title     { Faker::Lorem.sentence(
      word_count: 1, supplemental: false, random_words_to_add: 0)
    }
    body      { Faker::Lorem.paragraph }
    tag_names { Faker::Lorem.words(number: 3).join(",") }
  end

  commenters = 1.upto(3).map { FactoryGirl.create(:user, roles: [role[:user]]) }

  factory :comment do
    user { commenters.sample }
    body { Faker::Lorem.paragraph }
  end
end

10.times do
  user = FactoryGirl.create(:user, roles: [role[:admin]])
  putc '.'
  3.times do
    post = FactoryGirl.create(:post, user: user)
    putc '.'
    3.times { 
      FactoryGirl.create(:comment, post: post) 
      putc '.'
    }
  end
end

User.all.each do |user|
  r = rand(100_000)
  created, updated = r.minutes.from_now, (r + rand(10_000)).minutes.from_now
  user.update_columns(created_at: created, updated_at: updated)
end
