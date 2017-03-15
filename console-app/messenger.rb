#!/usr/bin/env ruby
class Sender
  require 'net/http'
  require 'readline'

  def self.send(line)
    uri = URI.parse("http://192.168.40.65:3000/generate")
    header = {'Content-Type' => 'application/json'}
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = line
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.request(request)
    App.show_wait_cursor(1)
    puts response.body.white
  end      
end

class App
  TEMPLATES = Dir[ '../templates/*' ].select{ |f| File.file? f }.map{ |f| File.basename f }
  LIST = %w(template to params).push(*TEMPLATES).sort

  def self.show_wait_cursor(seconds,fps=10)
    chars = %w[| / - \\]
    delay = 1.0/fps
    (seconds*fps).round.times{ |i|
      print chars[i % chars.length].magenta
      sleep delay
      print "\b"
    }
  end

  def self.run
    complete = proc { |s| LIST.grep(/^#{Regexp.escape(s)}/) }
    Readline.completion_append_character = " "
    Readline.completion_proc = complete
    loop do
      puts "> Enter params".cyan
      while line = Readline.readline('> '.cyan, true)
          Sender.send(line)  
      end
    end
  end
end

class String
  def magenta;        "\e[35m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def white;          "\e[37m#{self}\e[1m" end
end

App.run