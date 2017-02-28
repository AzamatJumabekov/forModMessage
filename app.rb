class App < Rack::App
  apply_extensions :front_end

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

  layout "layout.html.erb"

  desc 'some hello endpoint'
  post '/hello' do
    'ok'
    a = Handler.new(payload)
    a.render
  end

  post '/admin' do
    file = AdminTemplate.new(payload)
    file.write_to_file
    'ok'
  end 

  post '/delete' do
    template = AdminTemplate.new(payload)
    template.delete
  end

  get '/index' do
    @templates = Dir[ './assets/templates/*' ].select{ |f| File.file? f }.map{ |f| File.basename f }
    render 'index.html.erb'
  end

end


class Handler
  attr_reader :payload
  
  def initialize(payload)
    @payload = Hash[payload.map{|(k,v)| [k.to_sym,v]}]
  end

  def render
    begin
      message_text = Mustache.render(read_file(payload[:template])[:message][payload[:lang]], payload)
      write_to_file(message_text)
    rescue Mustache::ContextMiss => e
      e
    end
  end

  def read_file(filename)
    file = File.read('./assets/templates/' + filename + '.json')
    template = Hash[(JSON.parse(file)).map{|k,v| [k.to_sym,v]}]
  end

  def write_to_file(message)
    File.open('messages.json', 'a+') { |file| file.write(message + ', ')}
  end
end

class Mustache
  def self.raise_on_context_miss?
    @raise_on_context_miss = true
  end

  class Context
    def fetch(name, default = :__raise)
      @stack.each do |frame|
        next if frame == self

        value = find(frame, name, :__missing)
        return value if :__missing != value
      end

      if default == :__raise || mustache_in_stack.raise_on_context_miss?
        raise ContextMiss.new("Can't find #{name}")
      else
        default
      end
    end
  end
end

class AdminTemplate
  
  def initialize(params)
    @params = params
  end

  def new
  end

  def delete
    File.delete("./assets/templates/" + @params['name'] + ".json")
  end

  def update
  end

  def write_to_file
    json_attributes = JSON.generate(@params['template_attributes'])
    File.open("./assets/templates/" + @params['name'] + ".json", "w+") { |file| file.write(json_attributes) }
  end

  def edit
  end

end 