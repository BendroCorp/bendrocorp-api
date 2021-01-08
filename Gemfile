source 'https://rubygems.org'
ruby "2.6.5"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.6'

# Use Puma as the app server
gem 'puma', '~> 3.12'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

# jobs
gem 'sidekiq'
gem 'sidekiq-scheduler'

# push notifications
gem 'rpush'

# geocoding
gem 'geocoder'

# ?
gem 'rb-readline'

# one time password library
gem 'rotp'

# SendGrid for sending emails
gem 'mail'
gem 'sendgrid-ruby'

# payment processor
gem 'stripe'

# for checking to make sure good passwords are used
gem 'have-i-been-pwned'

# redis
# gem 'redis', '~> 3.0'

# jwt
gem 'jwt'

# auditing
gem 'paper_trail'

# file attachments
# DEPRECATED :(
gem 'paperclip' #, :git=> 'https://github.com/thoughtbot/paperclip'#, :ref => '523bd46c768226893f23889079a7aa9c73b57d68'
gem 'aws-sdk' #, '~> 2.3'

# prod database
gem 'pg'

# for web requsts to other apis and scraping :)
gem 'nokogiri'
gem 'httparty'

group :test do
 gem 'sqlite3'
end

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
