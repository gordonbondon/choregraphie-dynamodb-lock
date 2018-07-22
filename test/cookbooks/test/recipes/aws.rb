unless node['ec2']['aws_access_key_id'].nil? || node['ec2']['aws_access_key_id'].empty?
  directory '/root/.aws' do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end

  template '/root/.aws/credentials' do
    sensitive true
    source 'aws_credentials.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      'aws_access_key_id' => node['ec2']['aws_access_key_id'],
      'aws_secret_access_key' => node['ec2']['aws_secret_access_key'],
      'aws_session_token' => node['ec2']['aws_session_token']
    )
    action :create
  end
end
