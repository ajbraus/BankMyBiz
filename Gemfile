source 'https://rubygems.org'

ruby '1.9.3'
gem 'rails', '3.2.6'
gem 'heroku'
gem 'pg'
gem 'thin'

gem 'devise'
gem 'lazy_high_charts'
gem 'thumbs_up'
gem 'will_paginate'
gem 'will_paginate-bootstrap'
gem 'public_activity'
gem 'impressionist'

# gem 'impressionist'

gem 'whenever', require: false

gem 'jquery-rails'
gem 'twitter-bootstrap-rails'
gem "therubyracer"
gem 'less-rails' #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem 'coffee-rails', '~> 3.2.1'
gem 'jquery-ui-rails'

# group :development, :test do
# 	gem 'rspec-rails'
# 	gem 'turnip'
# 	gem 'capyabara'
# end

group :development do
	gem 'pry'
	gem 'pry-debugger'
  gem 'populator'
end

group :test do
  gem 'capybara', '1.1.2'
	gem 'factory_girl_rails', '1.4.0'
	gem 'email_spec', '1.2.1'
	gem 'guard-rspec', '1.1.0'
	gem "spork", '0.9.2'
	gem 'guard-spork', '1.1.0'
end

group :development, :test do 
	gem 'faker', '1.0.1'
  gem 'rspec-rails'
  gem 'awesome_print'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
	gem 'font-awesome-sass-rails'
  gem 'sass-rails',   '~> 3.2.3'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end