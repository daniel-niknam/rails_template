gem_group :development, :test do
  gem "rspec-rails", "~> 6.0"
  gem "standard"
  gem "standard-rails"
  gem "factory_bot_rails"
end

gem_group :test do
  gem "shoulda-matchers", "~> 6.0"
  gem "database_cleaner-active_record"
end

file "spec/support/shoulda_matcher.rb", <<~RUBY
  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end
RUBY

file "spec/support/database_cleaner.rb", <<~RUBY
  RSpec.configure do |config|
    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
    end

    config.around(:each) do |example|
      DatabaseCleaner.cleaning do
        example.run
      end
    end
  end
RUBY

file ".standard.yml", <<~YML
  fix: true               # default: false
  parallel: true          # default: false
  format: progress        # default: Standard::Formatter

  ignore:                 # default: []
    - 'vendor/**/*'

  plugins:                # default: []
    - standard-rails
YML

file "spec/support/factory_bot.rb", <<~RUBY
  RSpec.configure do |config|
    config.include FactoryBot::Syntax::Methods
  end
RUBY

after_bundle do
  rails_command "generate rspec:install"
  # uncomment requireing support files
  run "ruby -pi -e \"gsub(/^#\s(Rails.root.glob.*)/, '\\1')\" spec/rails_helper.rb"
end
