# This class parses templates and renders text
class Message
  attr_reader :payload
  def initialize(payload)
    @payload = payload
  end

  def template_render
    check_params(payload)
    template_text = read_file(payload['template'])['message']
    parse_template(template_text)
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

  private

  def parse_template(text)
    template = Liquid::Template.parse(text)
    rendered_text = template.render(payload['params'], strict_variables: true)
    raise LiquidTemplateMissing, template.errors if template.errors.any?
    return rendered_text
  end

  def check_params(params)
    Liquid::Template.error_mode = :warn
    keys = %w(template to)
    raise AttributesMissing.new if (keys - params.keys).any?
  end

  def write_to_file(message)
    File.open('messages.json', 'a+') { |file| file.write(message + ', ') }
  end

  def read_file(filename)
    path = File.expand_path('../../' + ENV['TEMPLATES_PATH'], __FILE__)
    JSON.parse(File.read(File.join(path, filename)))
  end

  def email_message
    {
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
    {
      'type' => 'sms',
      'phone_number' => payload['to'],
      'message' => template_render
    }
  end
end
