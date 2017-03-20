#!/usr/bin/env ruby
require_relative 'sender'

class App
  TEMPLATES = Dir[ '../templates/*' ].select{ |f| File.file? f }.map{ |f| File.basename f }
  LIST = %w(template to params).push(*TEMPLATES).sort

  def self.run
    complete = proc { |s| LIST.grep(/^#{Regexp.escape(s)}/) }
    Readline.completion_append_character = " "
    Readline.completion_proc = complete
    loop do
      puts "> Enter params".cyan
      while line = Readline.readline('> '.cyan, true)
          request = Sender.new
          request.send(line)
      end
    end
  end
end

App.run