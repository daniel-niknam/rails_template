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
