#!/usr/bin/env ruby
require_relative 'sender'

# This class starts console app
class App
  TEMPLATES = Dir['../templates/*'].select { |f| File.file? f }.map { |f| File.basename f }
  LIST = %w(template to params).push(*TEMPLATES).sort

  def self.run
    complete = proc { |s| LIST.grep(/^#{Regexp.escape(s)}/) }
    Readline.completion_append_character = ''
    Readline.completion_proc = complete
      loop do
        puts '> Enter params'.cyan
        line = Readline.readline('> '.cyan, true)
        case line
        when 'exit'
          break
        when 'help'
          puts 'Parameters must be passed as ruby Hash'
        else
          request = Sender.new
          response = request.send_request(line)
          puts response.body
        end
      end
  end
end
App.run
