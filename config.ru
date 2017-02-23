require 'rack/app'

require_relative 'app'

map '/' do
  run App
end