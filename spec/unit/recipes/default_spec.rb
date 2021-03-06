require 'spec_helper'

describe 'test::default' do
  context 'When all attributes are default, on ubutnu 16.04' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |n|
        n.normal['ec2']['placement_availability_zone'] = 'us-east-1a'
      end
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
