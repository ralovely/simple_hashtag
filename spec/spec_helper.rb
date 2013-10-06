ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rspec/rails'
require "rails/test_help"
require 'simple_hashtag'

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.after :all do
    ActiveRecord::Base.subclasses.each(&:delete_all)
  end
end
