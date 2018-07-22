name 'choregraphie_dynamodb_lock'
maintainer 'Artem Yarmoluk'
maintainer_email 'artem.yarmoluk@gmail.com'
license 'MIT'
description 'AWS DynamoDB lock primitive for chef choregraphie'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.2'
issues_url 'https://github.com/gordonbondon/choregraphie-dynamodb-lock/issues'
source_url 'https://github.com/gordonbondon/choregraphie-dynamodb-lock'
chef_version '>= 12.6' if respond_to?(:chef_version)

%w(amazon centos debian ubuntu).each do |os|
  supports os
end

depends 'choregraphie'
gem 'marloss'
