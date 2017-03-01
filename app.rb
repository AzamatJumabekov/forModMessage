class App < Rack::App

  apply_extensions :front_end

  layout "layout.html.erb"

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
    @payload = payload
  end

  def template_render
    Liquid::Template.error_mode = :warn
    keys = %w{ template lang }
    raise AttributesMissing.new if (keys - payload.keys).any?
    text = read_file(payload['template'])['message'][payload['lang']]
    template = Liquid::Template.parse(text)
    message_text = template.render(payload, strict_variables: true)
    write_to_file(message_text)
    raise LiquidTemplateMissing.new(template.errors) if template.errors.any?
    'ok'
  end

  def read_file(filename)
    file = JSON.parse(File.read('./assets/templates/' + filename))
  end

  def write_to_file(message)
    File.open('messages.json', 'a+') { |file| file.write(message + ', ')}
  end
end

class AttributesMissing < StandardError
  def message
    ['code': 'no template name', 'params': 'template or lang not passed' ]    
  end
end

class LiquidTemplateMissing < StandardError
  def initialize params
    @params = params
  end

  def message
    error = (@params.map { |e| e.message[/Liquid error: undefined variable (.+)/, 1] }).uniq
    message = ['code': 'params_missing', 'params': error ]
    return message
  end
end