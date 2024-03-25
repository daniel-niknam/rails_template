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
