source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.0'

gem 'rails', '~> 5.2.0.rc1'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'webpacker'

gem 'dry-configurable', '~> 0.7.0'

# Reduces boot times through caching; required in config/boot.rb
# gem 'bootsnap', github: 'Shopify/bootsnap', require: false

group :development, :test do
  gem 'rspec-rails', '~> 3.7'
  gem 'byebug'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'

  gem 'rubocop', require: false
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'
end
