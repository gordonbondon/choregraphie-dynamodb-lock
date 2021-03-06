# choregraphie_dynamodb_lock Cookbook

[![Build Status](https://travis-ci.org/gordonbondon/choregraphie-dynamodb-lock.svg?branch=master)](https://travis-ci.org/gordonbondon/choregraphie-dynamodb-lock) [![Cookbook Version](https://img.shields.io/cookbook/v/choregraphie_dynamodb_lock.svg)](https://supermarket.chef.io/cookbooks/choregraphie_dynamodb_lock)

This cookbook provides AWS DynamoDB lock primitive for [choregraphie](https://github.com/criteo-cookbooks/choregraphie) cookbook  

## Usage

Check choregraphie [documentation](https://github.com/criteo-cookbooks/choregraphie/blob/master/README.md) on how to use primitives in chef recipes.

### Primitive attributes

`:table` - (Required) name of a table to use  
`:hash_key` - (Required) DynamoDB table hash key name  
`:id` - (Required) unique id for lock name  
`:create_table` - (Optional) create DynamoDB table if it's missing. Default: `false`  
`:ttl` - (Optional) TTL for lock before it expires, in seconds. Default: `30`  
`:expires_key` - (Optional) Name of TTL attribute in table . Default: `Expires`  

Example:
```ruby
dynamodb_lock(table: 'LockTable', hash_key: 'id', id: 'my_node', ttl: 600)
```

### AWS Configuration

Block can be used to provide specific [AWS Config](https://docs.aws.amazon.com/sdk-for-ruby/v3/api/index.html#Configuration_Options):
```ruby
...
dynamodb_lock(table: 'LockTable', hash_key: 'id', id: 'my_node') do
  require 'aws-sdk-dynamodb'
  Aws.config.update({
    region: 'us-west-2',
  })
end
...
```

## Requirements

### Platforms

- Any platform supported by Chef and the AWS-SDK

### Chef

- Chef 12.6+

# References
* https://github.com/eredi93/marloss


