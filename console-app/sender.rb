require_relative 'string'
class Sender
  require 'net/http'
  require 'readline'

  def self.show_wait_cursor(seconds,fps=10)
    chars = %w[| / - \\]
    delay = 1.0/fps
    (seconds*fps).round.times{ |i|
      print chars[i % chars.length].magenta
      sleep delay
      print "\b"
    }
  end

  def self.send(line)
    uri = URI.parse("http://192.168.40.65:3000/generate")
    header = {'Content-Type' => 'application/json'}
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = line
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.request(request)
    self.show_wait_cursor(1)
    puts response.body.white
  end      
end