require 'rack/app'
require 'pry'
require 'liquid'
require 'rack/app/front_end'
require 'rack/static'

require_relative 'lib/admin_template'
require_relative 'lib/message'
require_relative 'hash'
require_relative 'app'
require_relative 'admin'

map '/' do
  run App
end

map '/admin' do
  run Admin
end