require 'rack/app'
require 'pry'
require 'mustache'
require 'rack/app/front_end'

require_relative 'app'

map '/' do
  run App
end