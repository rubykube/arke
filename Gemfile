# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.0'

gem 'rails', '~> 5.2.0.rc1'

# gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'

gem 'webpacker', '~> 3.3.1'

gem 'concurrent-ruby-edge', '~> 0.3.1', require: 'concurrent-edge'

gem 'dry-configurable', '~> 0.7.0'
gem 'dry-transaction', github: 'dry-rb/dry-transaction', ref: '406a188'

# Reduces boot times through caching; required in config/boot.rb
# gem 'bootsnap', github: 'Shopify/bootsnap', require: false

group :development, :test do
  gem 'byebug', '~> 10.0.0'
  gem 'pry', '~> 0.11.3'
  gem 'rspec-rails', '~> 3.7'
end

group :development do
  # Access an interactive console on exception pages
  # or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'

  gem 'rubocop', '0.54.0', require: false
end
