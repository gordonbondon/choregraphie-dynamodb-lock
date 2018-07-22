require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.before :each do
    # Reset Chef between all tests. Otherwise choregraphie blocks from various
    # specs are concatenated
    Chef::Config.reset
  end
end
