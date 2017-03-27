#!/usr/bin/env ruby
require_relative 'sender'

# This class starts console app
class App
  TEMPLATES = Dir['../templates/*'].select { |f| File.file? f }.map { |f| File.basename f }
  LIST = %w(template to params).push(*TEMPLATES).sort

  def run
    system('clear')
    print 'Available commands: '.white
    puts 'Help | Exit'.cyan
    autocompletion
    loop do
      puts '> Enter params'.cyan
      line = Readline.readline('> '.cyan, true)
      case line
      when 'exit' then break
      when 'help' then help_text
      else request(line)
      end
    end
  end

  private

  def help_text
    puts 'Params must be passed as: {
    "template": "template-name-here",
    "to": "receiver",
    "params": {
      "param1": "value1",
      "param2": "value2"
      }'
  end

  def request(line)
    request = Sender.new
    response = request.send_request(line)
    puts response.body
  end

  def autocompletion
    complete = proc { |s| LIST.grep(/^#{Regexp.escape(s)}/) }
    Readline.completion_append_character = ' '
    Readline.completion_proc = complete
  end
end
app = App.new
app.run
