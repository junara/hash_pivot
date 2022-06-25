# frozen_string_literal: true

require 'rspec-parameterized'
require 'active_record'
require 'factory_bot'
require_relative 'setup_database'

require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_group 'Repositories', 'lib/hash_pivot/repository'
  add_group 'Errors', 'lib/hash_pivot/error'
  enable_coverage :branch
  primary_coverage :branch
end
#
# if ENV['CI'] == 'true'
#   require 'codecov'
#   SimpleCov.formatter = SimpleCov::Formatter::Codecov
# end
require 'hash_pivot'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  # factory_bot initialization
  config.include FactoryBot::Syntax::Methods
  config.before(:suite) do
    FactoryBot.find_definitions
  end
end
