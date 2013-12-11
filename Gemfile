source 'https://rubygems.org'

ruby '1.9.3'
gem 'rails', '3.2.6'
gem 'heroku'
gem 'pg'
gem 'thin'
gem 'dotenv-rails', :groups => [:development, :test]

gem 'rack-cors', :require => 'rack/cors'

gem 'devise', '2.2.4'
gem 'devise_invitable', '~> 1.1.0'
gem 'gibbon'
gem 'omniauth-linkedin'
gem 'will_paginate'
gem 'will_paginate-bootstrap'
gem 'public_activity'
gem 'impressionist'
gem "therubyracer"
gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS

gem 'gibbon'

gem 'stripe'

gem "thumbs_up"

gem 'mysql2',          '0.3.12b5'
gem 'thinking-sphinx', '3.0.3' #'2.0.11'
gem 'flying-sphinx',   '1.0.0' #'0.8.4'

gem "rails_autolink", "~> 1.0.9"
gem "paperclip", "~> 3.0"
gem 'aws-sdk', '~> 1.3.4'
gem 'coffeebeans'

gem 'airbrake'
gem 'newrelic_rpm'

gem 'daemons'
gem 'delayed_job_active_record'

gem 'whenever', require: false

gem 'jquery-rails'
gem 'anjlab-bootstrap-rails', '~> 3.0.2.0', :require => 'bootstrap-rails'
gem 'coffee-rails', '~> 3.2.1'
gem 'jquery-ui-rails'

gem 'rabl'

group :development, :test do 
  gem 'rspec-rails'

  gem 'faker', '1.0.1'
  gem 'awesome_print'
  #   gem 'turnip' 
end

group :development do
	gem 'pry'
	gem 'pry-debugger'
  gem 'populator'
end

group :test do
  gem 'factory_girl_rails'
  gem 'capybara', '1.1.2'
	gem 'email_spec', '1.2.1'
	gem "spork-rails"
  gem 'database_cleaner'
  #gem 'guard-rspec', '1.1.0'
	#gem 'guard-spork', '1.1.0'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'sass'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end

gem 'rails_12factor', group: :production