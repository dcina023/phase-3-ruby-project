# frozen_string_literal: true

source "https://rubygems.org"

# An object-relational mapper
# https://guides.rubyonrails.org/active_record_basics.html
gem "activerecord", "~> 7.1"

# Run common tasks from the command line
# https://github.com/ruby/rake
gem "rake", "~> 13.0"

# Provides functionality to interact with a SQLite3 database
gem "sqlite3", "~> 1.7"

# Require all files in a folder
gem "require_all", "~> 3.0"

gem "standalone_migrations"

gem "tty-prompt"

gem "tty-font"

gem "pastel"

# Generate mock data for database seeds
gem "faker"

# These gems will only be used when we are running the application locally
group :development do
  gem "pry", "~> 0.14.1"

  # Ruby linter and formatter
  # https://github.com/rubocop/rubocop
  gem "rubocop"
end

# These gems will only be used when we are running tests
group :test do
  gem "database_cleaner", "~> 2.0"
  gem "rspec", "~> 3.10"
end
