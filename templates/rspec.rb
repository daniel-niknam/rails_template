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
