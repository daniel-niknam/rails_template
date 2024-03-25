def rails_version
  Gem::Version.new(Rails.version)
end

def rspec
  if yes?("Add rspec? (y/N)")
    gem_group :development, :test do
      # rspec-rails 6.x for Rails 6.1 or 7.x.
      # rspec-rails 5.x for Rails 5.2 or 6.x.
      # rspec-rails 4.x for Rails from 5.x or 6.x.
      # rspec-rails 3.x for Rails earlier than 5.0.
      # rspec-rails 1.x for Rails 2.x.
      if rails_version == "6.1" || rails_version > "7"
        gem "rspec-rails", "~> 6.0"
      elsif rails_version == "5.2" || rails_version > "6"
        gem "rspec-rails", "~> 5.0"
      elsif rails_version > "5.0"
        gem "rspec-rails", "~> 4"
      elsif rails_version > "3.0"
        gem "rspec-rails", "~> 3"
      else
        gem "rspec-rails", "~> 1"
      end
    end

    after_bundle do
      rails_command "generate rspec:install"
      # uncomment requireing support files
      run "ruby -pi -e \"gsub(/^#\s(Rails.root.glob.*)/, '\\1')\" spec/rails_helper.rb"
      run "mkdir -p spec/support"
    end
  end
end

def shoulda_matcher
  if yes?("Add Shoulda matcher? (y/N)")
    gem_group :test do
      gem "shoulda-matchers", "~> 6.0"
    end

    file "spec/support/shoulda_matcher.rb", <<~RUBY
      Shoulda::Matchers.configure do |config|
        config.integrate do |with|
          with.test_framework :rspec
          with.library :rails
        end
      end
    RUBY
  end
end

def database_cleaner
  if yes?("Add Database Cleaner? (y/N)")
    adapters_list = ["active_record", "sequel", "mongo", "mongoid", "redis"]
    adapters = {}

    adapters_list.each do |adapter|
      adapters[adapter] = yes?("Using #{adapter}? (y/N)")
    end

    return if adapters.empty?

    gem_group :test do
      adapters.each do |adapter, want|
        gem "database_cleaner-#{adapter}" if want
      end
    end

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
  end
end

def standardrb
  if yes?("Add Standard RB? (y/N)")
    gem_group :development, :test do
      gem "standard"
      gem "standard-rails"
    end

    file ".standard.yml", <<~YML
      fix: true               # default: false
      parallel: true          # default: false
      format: progress        # default: Standard::Formatter

      ignore:                 # default: []
        - 'vendor/**/*'

      plugins:                # default: []
        - standard-rails
    YML
  end
end

def factory_bot
  gem_group :development, :test do
    gem "factory_bot_rails"
  end

  file "spec/support/factory_bot.rb", <<~RUBY
    RSpec.configure do |config|
      config.include FactoryBot::Syntax::Methods
    end
  RUBY
end

# run
rspec
shoulda_matcher
database_cleaner
standardrb
factory_bot
