require_relative 'string'
require 'net/http'
require 'readline'

# It sends http POST request to web-app
class Sender
  def show_wait_cursor(seconds, fps = 10)
    chars = %w(| / - \\)
    delay = 1.0 / fps
    (seconds * fps).round.times do |i|
      print chars[i % chars.length].magenta
      sleep delay
      print "\b"
    end
  end

  def send_request(line)
    uri = URI.parse('http://web-app:3000/generate')
    header = { 'Content-Type' => 'application/json' }
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = line
    http = Net::HTTP.new(uri.host, uri.port)
    show_wait_cursor(1)
    http.request(request)
  end
end
