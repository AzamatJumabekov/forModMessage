require 'rack/app'
require 'pry'
require 'liquid'
require 'rack/app/front_end'

require_relative 'app'
require_relative 'admin'

map '/' do
  run App
end

map '/admin' do
  run Admin
end