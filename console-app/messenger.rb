#!/usr/bin/env ruby
class Sender
  require 'net/http'
  require 'readline'
  require 'pry'

  templates = Dir[ '../templates/*' ].select{ |f| File.file? f }.map{ |f| File.basename f }
  LIST = %w(template to params).push(*templates).sort

  def initialize
    @uri = URI.parse("http://192.168.1.103:9393/generate")
  end
  def sender_params
    header = {'Content-Type' => 'application/json'}
    Net::HTTP::Post.new(@uri.request_uri, header)
  end

  def sender(line)
    request = sender_params
    http = Net::HTTP.new(@uri.host, @uri.port)
    request.body = line
    response = http.request(request)
    show_wait_cursor(1)
    puts response.body.white
  end


  def show_wait_cursor(seconds,fps=10)
    chars = %w[| / - \\]
    delay = 1.0/fps
    (seconds*fps).round.times{ |i|
      print chars[i % chars.length].magenta
      sleep delay
      print "\b"
    }
  end

  def run
    complete = proc { |s| LIST.grep(/^#{Regexp.escape(s)}/) }
    Readline.completion_append_character = " "
    Readline.completion_proc = complete
    loop do
      puts "> Enter params".cyan
      while line = Readline.readline('> '.cyan, true)
        sender(line)
      end
    end    
  end    
end
class String
  def magenta;        "\e[35m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def white;          "\e[37m#{self}\e[1m" end
end

app = Sender.new
app.run