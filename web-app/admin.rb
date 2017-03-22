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
    @templates = AdminTemplate.templates_list
    render 'index.html.erb'
  end

  get '/new' do
    render 'new.html.erb'
  end

  post '/create' do
    new_template = AdminTemplate.new(payload)
    if new_template.create
      redirect_to 'show/' + new_template.get_file_name
    else
      redirect_to 'admin/index'
    end
  end

  get '/show/:template' do
    file = AdminTemplate.new(params)
    @file = file.show
    @file_name = params['template']
    render 'show.html.erb'
  end

  get '/edit/:template' do
    file = AdminTemplate.new(params)
    @file = file.edit
    @file_name = params['template']
    render 'edit.html.erb'
  end

  post '/update' do
    edited_file = AdminTemplate.new(payload)
    if edited_file.update
      redirect_to 'show/' + edited_file.get_file_name
    else
      redirect_to 'admin/index'
    end
  end

end