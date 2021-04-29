# frozen_string_literal: true

require 'faker'
require 'mongoid'
require 'validates_timeliness/mongoid'

Dir['spec/support/faker/*.rb'].each do |class_example|
  require File.expand_path(class_example)
end

Mongoid.configure do |config|
  config.connect_to('validates_timeliness_test')
end

RSpec.configure do |config|
  config.fail_fast = true
  config.filter_run_excluding broken: true

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
