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
