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
    if payload.nil?
      raise StandardError.new("nil params")
    end
    if payload.is_a?(Hash)
      hash = payload
    else
      hash = JSON.parse(payload)
    end
    message = Message.new(hash)
    message.generate_message
    'ok'
  end

end