class Admin < Rack::App

  apply_extensions :front_end

  layout "layout.html.erb"

  serve_files_from '/www'

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

  post '/delete' do
    template = AdminTemplate.new(payload['filename'])
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