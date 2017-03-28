# This is a controller and routes for api
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
    hash = Validate.params(payload)
    message = Message.new(hash)
    response.status = 201 if message.generate_message
  end
end
