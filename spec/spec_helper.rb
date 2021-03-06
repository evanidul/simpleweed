# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

# dvu: add 2 lines to get coverage report.  Wondering if it's causing selenium delays, so commenting out.
if ENV['COVERAGE'] == "true"
  require 'simplecov'
  SimpleCov.start
end

# solar search index testing
require 'sunspot_test/rspec'

# verify registration emails
require "email_spec"

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

if ENV['UNICORN'] == "true"
  Capybara.server do |app, port|
    Unicorn::Configurator::RACKUP[:port] = port
    Unicorn::Configurator::RACKUP[:set_listener] = true

    server = Unicorn::HttpServer.new(app)
    server.start
  end
end

# require all files in spec/support automatically
Dir[Rails.root.join('spec/support/**/*.rb')].each { |file| require file }

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # dvu: stuff deprecation warnings into a file
  #config.deprecation_stream = 'log/deprecations.log'
  # or  ...doesnt' WORK!
  #config.deprecation_stream = File.open("#{::Rails.root}/log/testdeprecations", "w")

  # from http://robots.thoughtbot.com/automatically-wait-for-ajax-with-capybara
  # gives us a function to wait for ajax to complete in tests
  config.include WaitForAjax, type: :feature

  # dvu: try and add waits for modals
  config.include BootstrapModal, type: :feature

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # include for email_spec gem
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)

  # use FactoryGirl short hand methods in tests (like build(:user))
  config.include FactoryGirl::Syntax::Methods

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.before(:suite) do    
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
    if defined? page
      page.driver.browser.manage.window.maximize
    end
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end
