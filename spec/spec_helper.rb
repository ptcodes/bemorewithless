require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'capybara/rails'
  require 'capybara/rspec'
  require 'capybara/dsl'
  require 'factory_girl'

  Capybara.ignore_hidden_elements = true
  Capybara.javascript_driver = :webkit

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.before do
      ActiveRecord::Base.observers.disable :all
    end

    config.mock_with :rspec, :mocha
    config.use_transactional_fixtures = true
    config.infer_base_class_for_anonymous_controllers = false

    ActiveSupport::Dependencies.clear

    config.include FactoryGirl::Syntax::Methods
  end
end
