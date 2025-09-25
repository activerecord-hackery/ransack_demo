source "https://rubygems.org"

ruby file: ".ruby-version"

gem "rails", "~> 8.0.0"

# Use PostgreSQL as the database for Active Record
gem "pg", "~> 1.0"
# Use Puma as the app server
gem "puma", "~> 6.0"
# Use Tailwind CSS for styling
gem "tailwindcss-rails", "~> 2.0"
# Use Importmap for managing JavaScript dependencies
gem "importmap-rails", "~> 2.0"
# Turbo provides partial page replacement and forms without full page reloads
gem "turbo-rails", "~> 2.0"
# Stimulus provides reactive behavior for JavaScript
gem "stimulus-rails", "~> 1.0"
# Use SCSS for stylesheets
gem "sass-rails", "~> 6.0"
# Use jquery as the JavaScript library
gem "jquery-rails"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem "ransack"
gem "factory_bot"
gem "faker"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platform: :mri
  # System testing gems
  gem "selenium-webdriver"
  gem "webdrivers"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem "web-console"
  gem "listen", "~> 3.0.5"

  gem "rubocop", "~> 1.29"
end
