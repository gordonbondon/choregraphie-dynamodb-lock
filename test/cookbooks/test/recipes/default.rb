execute 'converging' do
  command 'sleep 60'
end

choregraphie 'execute' do
  on 'execute[converging]'

  dynamodb_lock(table: 'lock_table', hash_key: 'lock_id', id: 'my_lock', ttl: 300, create_table: false) do
    require 'aws-sdk-dynamodb'
    Aws.config.update(
      region: node['ec2']['placement_availability_zone'].chop
    )
  end
end
