# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.1'

gem 'nanoid'
gem 'pg'
gem 'puma'
gem 'rack-contrib'
gem 'rack-sassc'
gem 'rake'
gem 'redis'
gem 'sassc'
gem 'sinatra'
gem 'sinatra-activerecord'
gem 'sinatra-contrib'

group :development do
  gem 'htmlbeautifier'
  gem 'solargraph'
end

group :test do
  gem 'database_cleaner-active_record'
  gem 'database_cleaner-redis'
  gem 'rack-test'
  gem 'rspec'
end
