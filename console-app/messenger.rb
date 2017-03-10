#!/usr/bin/env ruby
require 'net/http'

uri = URI.parse("http://192.168.40.67:3000/generate")
header = {'Content-Type' => 'application/json'}

# Create the HTTP objects
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Post.new(uri.request_uri, header)
request.body = ARGV[0]

# Send the request
response = http.request(request)
puts response.body