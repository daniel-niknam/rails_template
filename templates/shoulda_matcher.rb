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
