
source 'https://rubygems.org' do

  platform(:rbx) do
    gem 'rubysl'
    gem 'ffi'
    # Use Psych as the YAML engine, instead of Syck, so serialized data can be read safely
    #  from different rubies (see http://git.io/uuLVag)
    gem 'psych'
  end

  gem 'rails'#, '>= 4.0.1'
  gem 'rake'#, '>= 0.9.2.2'
  # gem 'rack'#, '>= 1.4.1'
  # Use mysql as the database for Active Record
  gem 'mysql2'
  # Use SCSS for stylesheets
  gem 'sass-rails'#, '~> 5.0'
  # Use Uglifier as compressor for JavaScript assets
  gem 'uglifier'#, '>= 1.3.0'
  # Use CoffeeScript for .coffee assets and views
  gem 'coffee-rails'#, '~> 4.1.0'
  gem 'execjs'#, '>= 1.3.0' # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', platforms: :ruby

  # Use jquery as the JavaScript library
  gem 'jquery-rails'#, '>= 3.0.0'
  gem 'jquery-ui-rails'#, '>= 5.0.0'
  gem 'jquery-turbolinks'
  gem 'turbolinks' # makes links load faster; see https://github.com/rails/turbolinks
  # gem 'jquery_datepicker' # rails 4 incompatible 2013-06-29
  gem 'bettertabs'

  gem 'json'#, '>= 1.6.6'
  # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
  gem 'jbuilder'#, '~> 2.0'

  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc'#, '~> 0.4.0', group: :doc

  gem 'fcgi'

  group :development do
    gem 'capistrano', require: false#, '>= 3.0.1'
    gem 'capistrano-rails', require: false
    gem 'capistrano-bundler', require: false
    gem 'capistrano-rvm', require: false
    # gem 'capistrano-puma', require: false # use service instead

    # gem 'capistrano-ci' # not cap3 compatible yet https://github.com/railsware/capistrano-ci/pull/4
    gem 'term-ansicolor'
    platform(:mri) do # Ruby 2.0+ required.
      gem 'byebug'
      gem 'pry-byebug'
    end
    platform(:rbx) do
      gem 'rubinius-compiler'
      gem 'rubinius-debugger'
    end

    gem 'pry'
    gem 'pry-rails'
    gem 'pry-doc'
    gem 'pry-git'
    gem 'awesome_print'

    gem 'pry-rescue'
    gem 'pry-stack_explorer'

    gem "better_errors"
    gem "binding_of_caller"
  end

  # Bundle gems for the local environment. Make sure to
  # put test-only gems in this group so their generators
  # and rake tasks are available in development mode:
  group :development, :test do
    platform(:mri) { gem 'ruby-prof' }
    gem 'webrat'#, '>= 0.7.3'
    gem "brakeman", require: false  # Rails security scanner
    gem 'rubocop', require: false
    gem 'bundler-audit', require: false
    # gem 'rspec-rails'#, '~> 3.0.0.beta'
    gem 'spring'
  end

  group :test do
    # gem 'cucumber-rails', :require => false
    gem 'database_cleaner'
  end

  gem 'activerecord-mysql-unsigned'
  gem 'mysql_big_table_migration'
  gem 'Empact-activerecord-import'#, '>= 0.4.1' # zdennis hasn't yet imported the import profiling fix; this is a bugfix tracking fork

  gem 'groupdate' # https://github.com/ankane/groupdate

  gem "strip_attributes"#, ">= 1.1.0"
  # gem 'client_side_validations' # rails 4 incompatible

  gem 'friendly_id'#, ">= 5.0.0"

  # gem 'ssn_validator'
end
