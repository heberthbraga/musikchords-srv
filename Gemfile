source 'https://rubygems.org'

gem 'rails', '3.2.8'
gem 'jquery-rails'
gem 'mongo_mapper'
gem 'bson_ext'
gem 'mongomapper_i18n'
gem 'devise'
gem 'mm-devise'
gem 'cancan'
gem 'kaminari', '~> 0.13.0'
gem 'devise-encryptable'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'factory_girl_rails', '~> 4.0.0'
  gem 'debugger'
end

group :test do
  gem "database_cleaner"
  gem 'shoulda', '~> 2.11.3'
  gem 'mocha',   '~> 0.12.3'
  gem 'always_execute', '0.0.2', :require => nil
  gem 'simplecov', :require => false
end