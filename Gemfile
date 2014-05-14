source 'https://rubygems.org'

gem 'net-ssh', '2.5.2'
gem 'rails' #, '3.2.14'
gem 'jquery-rails'
gem 'slim'
gem 'slim-rails'
gem 'dynamic_form'
gem 'will_paginate', '~> 3.0'
gem 'bootstrap-will_paginate'
gem 'rmagick'
gem 'decent_exposure'
gem 'roo'
gem 'prawn'

gem 'omniauth'
gem 'omniauth-openid'
gem 'omniauth-daum'
gem 'omniauth-nate'
gem 'google_apps'

gem 'pony'
gem 'by_star'

gem 'bootstrap-sass'#, '= 2.1.1.0'
gem 'simple_calendar'

gem 'unicorn'
gem 'capistrano'
gem 'capistrano-unicorn'
gem 'rvm-capistrano'

gem 'ucloud_storage', github: 'wangsy/ucloud-storage'

group :assets, :dev do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  gem 'therubyracer', :platforms => :ruby, :require => 'v8'
  #gem 'libv8'
  gem 'libv8', '~> 3.11.8'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'pow-client'
  # gem 'sextant'
  #gem 'debugger'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
end

group :test do
  gem 'growl'
  gem 'test-unit', require: false
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'database_cleaner', '~> 1.0.0'
end


group :development, :test do
  gem "capybara", "~> 1.1.2"
  gem 'sqlite3'
  gem 'mysql2'
  gem 'dotenv-rails' # https://github.com/bkeepers/dotenv
end

group :production do
  gem 'mysql2'
end
