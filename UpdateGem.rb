require 'rest-client'

# Get Gem API Key, write it into ~/.gem/credentials

rubyGemUserName = ENV['RUBYGEMSUSERNAME']
rubyGemPass = ENV['RUBYGEMSPASSWORD']

token = RestClient::Request.new(
  :method => :get,
  :url => 'https://rubygems.org/api/v1/api_key.yaml',
  :user => rubyGemUserName,
  :password => rubyGemPass,
).execute

Dir.mkdir Dir.home + '/.gem'
File.open(Dir.home + '/.gem/credentials', 'w') { |file| file.write(token) }
