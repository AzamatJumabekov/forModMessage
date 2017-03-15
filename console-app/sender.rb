require_relative 'string'
require 'net/http'
require 'readline'
require 'pry'
class Sender

  def show_wait_cursor(seconds,fps=10)
    chars = %w[| / - \\]
    delay = 1.0/fps
    (seconds*fps).round.times{ |i|
      print chars[i % chars.length].magenta
      sleep delay
      print "\b"
    }
  end

  def send(line)
    uri = URI.parse("http://localhost:9393/generate")
    header = {'Content-Type' => 'application/json'}
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = line
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.request(request)
    show_wait_cursor(1)
    puts response.body
    return response
  end
end