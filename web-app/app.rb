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

  desc 'handles requests for creating messages'

  post '/generate' do
    something = Message.new(payload)
    something.generate_message
    'ok'
  end

end


class Message
  attr_reader :payload
  
  def initialize(payload)
    @payload = payload
  end

  def template_render
    Liquid::Template.error_mode = :warn
    keys = %w{ template }
    raise AttributesMissing.new if (['template'] - payload.keys).any?
    text = read_file(payload['template'])['message']
    template = Liquid::Template.parse(text)
    message_text = template.render(payload['params'], strict_variables: true)
    raise LiquidTemplateMissing.new(template.errors) if template.errors.any?
    return message_text
  end

  def read_file(filename)
    file = JSON.parse(File.read('./assets/templates/' + filename))
  end

  def write_to_file(message)
    File.open('messages.json', 'a+') { |file| file.write(message + ', ')}
  end

  def generate_message
    message = {}

    if payload['template'].include? 'SMS'
      message.merge!(sms_message)
    elsif payload['template'].include? 'EMAIL'
      message.merge!(email_message)
    end

    json = JSON.pretty_generate(message)
    write_to_file(json)
    
  end

  def email_message
    new_message = {
      'type' => 'email',
      'email' => payload['to'],
      'message' => {
        'subject' => payload['subject'],
        'body' => template_render,
        'body_html' => '<h1>' + template_render + '</h1>'
      }
    }
  end

  def sms_message
    new_message = {
      'type' => 'sms',
      'phone_number' => payload['to'],
      'message' => template_render
    }
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