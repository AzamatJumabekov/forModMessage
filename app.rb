class App < Rack::App

  serializer do |obj|
    if obj.is_a?(String)
      obj
    else
      JSON.dump(obj)
    end
  end

  error StandardError, NoMethodError do |ex|
    { error: ex.message }
  end

  payload do
    parser do
      accept :json, :www_form_urlencoded
    end
  end

  desc 'some hello endpoint'
  post '/hello' do
    'ok'
    a = Handler.new(payload)
    a.render
  end

end

class Handler
  attr_reader :payload
  
  def initialize(payload)
    @payload = Hash[payload.map{|(k,v)| [k.to_sym,v]}]
  end

  def render
    begin
      Mustache.render(read_file(payload[:template])[:message][payload[:lang]], payload)
    rescue Mustache::ContextMiss => e
      puts e
    end
  end

  def read_file(filename)
    file = File.read('./assets/templates/' + filename + '.json')
    template = Hash[(JSON.parse(file)).map{|k,v| [k.to_sym,v]}]
  end

  def write_to_file
    File.open('messages.json', 'a+') { |file| file.write(json)}
  end
end

class Mustache
  def self.raise_on_context_miss?
    @raise_on_context_miss = true
  end
end