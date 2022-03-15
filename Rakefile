# frozen_string_literal: true

require 'sinatra/activerecord/rake'

namespace :db do
  task :load_config do
    require_relative 'app/application'
  end
end

require 'rspec/core/rake_task'

namespace :spec do
  desc 'Run all examples'
  RSpec::Core::RakeTask.new('all')
end
