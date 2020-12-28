# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.4'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'rails', '~> 6.0.0'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  %w[rspec-core rspec-expectations rspec-mocks rspec-rails rspec-support].each do |lib|
    gem lib, git: "https://github.com/rspec/#{lib}.git", branch: 'master'
  end
  gem 'factory_bot_rails', '5.2.0'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop', require: false
  gem 'sorbet'
  gem 'sorbet-rails'
  gem 'sorbet-runtime'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'rspec-sorbet'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
