require 'rack/app'
require 'pry'
require 'liquid'
require 'rack/app/front_end'
require 'rack/static'

Dir["#{File.dirname(__FILE__)}/lib/**/*.rb"].each { |file| require file }
require_relative 'app'
require_relative 'admin'

map '/' do
  run App
end

map '/admin' do
  run Admin
end
