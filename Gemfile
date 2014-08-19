source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.4'

# Use postgresql as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.2'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# authentication, user registration
gem 'devise' 

# https://github.com/alexreisner/geocoder :: get lat/long for addresses and nearby location services
gem 'geocoder'

# https://github.com/adam12/tzwhere :: get timezone info from lat/long
gem 'tzwhere' 

# authorization lib : https://github.com/CanCanCommunity/cancancan
gem 'cancancan', '~> 1.7'

# roles per model (ie, this user is the store manager for Store #5)
gem "rolify"

# test coverage : https://github.com/colszowka/simplecov
gem 'simplecov', :require => false, :group => :test

# rails client for solr
gem 'sunspot_rails'
# solr service (instead of deploying java war)
gem 'sunspot_solr' # optional pre-packaged Solr distribution for use in development

# needed to run selenium tests with solr index access
gem 'sunspot_test' , :group => :test

# multithreaded rails server.  Replaces webbrick.
# see /config/unicorn.rb & /ProcFile for configuration
gem 'unicorn'

# new relic, app monitoring heroku add on
gem 'newrelic_rpm'

# allows you to run 'rails generate active_record:session_migration', which allows you to store sessions in the db
gem 'activerecord-session_store', github: 'rails/activerecord-session_store'

# powers user feeds
gem 'public_activity'

# allows you to follow people, etc
gem "socialization"

# allows you to flag objects (https://github.com/medihack/make_flaggable)
gem 'make_flaggable', :git => 'https://github.com/medihack/make_flaggable.git'

# delayed jobs allows you to send mail asynchronously
gem 'delayed_job_active_record'

# amazon sdk for s3 file/photo uploads
gem 'aws-sdk'

# https://github.com/andrewculver/koudoku, stripe + subscription management
gem 'koudoku'

# https://github.com/radar/paranoia, allows soft deletes (store items)
gem "paranoia", "~> 2.0"

group :development, :test do
  # automated testing
  gem 'rspec-rails', '~> 3.0.0.beta'
  
  # Selenium test driver
  gem 'capybara'

  # Selenium test driver
  gem 'selenium-webdriver'
  
  # truncates the db after Selenium tests
  gem 'database_cleaner' 
  
  # allows you to use Page Pattern for Selenium tests: https://github.com/natritmeyer/site_prism
  gem 'site_prism'

  # break points in tests
  gem 'pry'

  # allows you test test devise registration emails
  gem 'email_spec'
  # https://github.com/p0deje/action_mailer_cache_delivery  
  gem 'action_mailer_cache_delivery'

end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false

  #heroku docs modifications
  gem 'rails_12factor', group: :production

  ruby "2.0.0"

  # Credit Card processing....still waiting to see if we can use this..
  gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'

  gem 'bootstrap-sass', '~> 3.0.3.0'
  group :development do
    gem 'rails_layout'
  end

end


# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
