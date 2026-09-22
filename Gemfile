source "https://rubygems.org"

ruby file: ".ruby-version"

gem "rails", "~> 8.1.3", ">= 8.1.3.1"

# Use PostgreSQL as the database for Active Record
gem "pg", "~> 1.6"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 6.0"
# Asset pipeline and jQuery, used by the dynamic search form
gem "sprockets-rails"
gem "jquery-rails"

# The star of the show
gem "ransack", "~> 5.0"

# Seed data
gem "factory_bot"
gem "faker"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"

  # Audits gems for known security defects (use config/bundler-audit.yml to ignore issues)
  gem "bundler-audit", require: false

  gem "rubocop", require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem "web-console"
end
