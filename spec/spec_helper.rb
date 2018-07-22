require 'chefspec'
require 'chefspec/berkshelf'
require 'aws-sdk-dynamodb'

RSpec.configure do |config|
  config.before :each do
    # Reset Chef between all tests. Otherwise choregraphie blocks from various
    # specs are concatenated
    Chef::Config.reset
    Aws.config.update(stub_responses: true)
  end
end
