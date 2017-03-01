class Admin < Rack::App

  apply_extensions :front_end

  layout "layout.html.erb"

  payload do
    parser do
      accept :json, :www_form_urlencoded
    end
  end

  post '/admin' do
    file = AdminTemplate.new(payload)
    file.write_to_file
    'ok'
  end 

  get '/delete/:filename' do
    template = AdminTemplate.new(params['filename'])
    template.delete
    redirect_to '/admin/index'
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
    redirect_to '/admin/index'
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
    redirect_to '/admin/index'
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