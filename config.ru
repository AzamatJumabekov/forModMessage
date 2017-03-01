require 'rack/app'
require 'pry'
require 'liquid'
require 'rack/app/front_end'

require_relative 'app'

map '/' do
  run App
end