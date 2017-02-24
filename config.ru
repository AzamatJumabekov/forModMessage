require 'rack/app'
require 'pry'
require 'mustache'

require_relative 'app'

map '/' do
  run App
end