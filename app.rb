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

  get '/delete/:filename' do
    template = AdminTemplate.new(params['filename'])
    template.delete
    redirect_to '/index'
  end

  get '/index' do
    @templates = Dir[ './assets/templates/*' ].select{ |f| File.file? f }.map{ |f| File.basename f }
    render 'index.html.erb'
  end

  get '/new' do
    render 'new.html.erb'
  end

  post '/create' do
    new_template = AdminTemplate.new(payload)
    new_template.write_to_file
    redirect_to '/index'
  end

  get '/show/:template' do
    file = AdminTemplate.new(params)
    @file = file.show
    @file_name = params['template']
    render 'show.html.erb'
  end

  get '/edit/:template' do
    file = AdminTemplate.new(params)
    @file = file.show
    @file_name = params['template']
    render 'edit.html.erb'
  end

  post '/update' do
    edited_file = AdminTemplate.new(payload)
    edited_file.update
    redirect_to '/index'
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

class AdminTemplate
  
  def initialize(params)
    @params = params
  end

  def show
    file = File.read('./assets/templates/' + @params['template'])
  end

  def delete
    File.delete("./assets/templates/" + @params)
  end

  def update
    if @params['old_name'] != @params['name']
      File.rename("./assets/templates/" + @params['old_name'], "./assets/templates/" + @params['name'])
    end
    write_to_file
  end

  def write_to_file
    File.open("./assets/templates/" + @params['name'], "w+") { |file| file.write(@params['template_attributes']) }
  end

  def edit
    file = File.read('./assets/templates/' + @params['template'])
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