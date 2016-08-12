source 'https://rubygems.org'
ruby '2.3.1'

# Bundle Rails master:
gem 'rails', github: 'rails/rails'

# gem 'rails', '5.0.1'

gem 'sqlite3'
gem 'ransack'

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

gem 'jquery-rails'
gem 'puma'

group :development do
  gem 'faker'
end

group :test do
  gem 'turn', require: false
end

group :development, :test do
  gem 'factory_girl'
  gem 'pry-awesome_print'
  gem 'pry-highlight'
  gem 'pry-rails'
end
