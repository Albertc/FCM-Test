# frozen_string_literal: true

Dir["app/**/*.rb"].each { |file| require_relative "../#{file}" }
Dir["lib/**/*.rb"].each { |file| require_relative "../#{file}" }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.example_status_persistence_file_path = 'spec/examples.txt'

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
    mocks.verify_doubled_constant_names = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
