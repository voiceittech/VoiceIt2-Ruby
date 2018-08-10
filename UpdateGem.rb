=begin
require 'rest-client'

# Get Gem API Key

rubyGemUserName = ENV['RUBYGEMSUSERNAME']
rubyGemPass = ENV['RUBYGEMSPASSWORD']

ret = RestClient::Request.new(
  :method => :get,
  :url => 'https://rubygems.org/api/v1/api_key.yaml',
  :user => rubyGemUserName,
  :password => rubyGemPass,
  ).execute

  File.open('~/Desktop/.gem/credentials2', 'w') { |file| file.write(ret) }
=end

puts File.directory?(Dir.home + '/.gem')
