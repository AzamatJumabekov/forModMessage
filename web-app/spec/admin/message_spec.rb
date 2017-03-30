RSpec.describe Message do
  
  before(:each) do
    FileUtils.rm_r Dir.glob('spec/templates/*')
    FileUtils.cp_r 'spec/templates_for_test/.', 'spec/templates/.'
  end

  payload = {
    'template' => 'SMS_OTP_RU',
    'to' => '+95745732234',
    'params' => { 'code' => '4353' }
  }

  it 'Получает готовое сообщение для записи, метод template_render' do
    message = Message.new(payload)
    expect(message.template_render).to eq('OpenWallet. Код подтверждения - 4353. Никому не сообщайте этот код.')
  end

  it 'Генерирует сообщение типа SMS, метод generate_message' do
    message = Message.new(payload)
    File.truncate('messages.json', 0)
    message.generate_message
    file = File.read("messages.json")
    expect(file).to eq("{\n  \"type\": \"sms\",\n  \"phone_number\": \"+95745732234\",\n  \"message\": \"OpenWallet. Код подтверждения - 4353. Никому не сообщайте этот код.\"\n}, ")
  end

  it 'Генерирует сообщение типа EMAIL, метод generate_message' do
    payload['template'] = 'EMAIL_OTP_RU'
    payload.store('subject', 'Secret code')
    payload['to'] = 'lakiwolf.90@mail.ru'
    binding.pry
    message = Message.new(payload)
    File.truncate('messages.json', 0)
    message.generate_message
    file = File.read("messages.json")
    expect(file).to eq("{\n  \"type\": \"email\",\n  \"email\": \"lakiwolf.90@mail.ru\",\n  \"message\": {\n    \"subject\": \"Secret code\",\n    \"body\": \"OpenWallet. Код подтверждения - 4353. Никому не сообщайте этот код.\",\n    \"body_html\": \"<h1>OpenWallet. Код подтверждения - 4353. Никому не сообщайте этот код.</h1>\"\n  }\n}, ")
  end

  # post '/generate' do
  #   hash = Validate.params(payload)
  #   message = Message.new(hash)
  #   response.status = 201 if message.generate_message
  # end

  # it 'should return error with code "attributes missing" and text "template or to not passed"' do
  #   payload = {}
  #   message = Message.new(payload)
  #   begin
  #     message.template_render
  #   rescue AttributesMissing => e
  #     expect(e.message.first[:code]).to eq('attributs missing')
  #     expect(e.message.first[:params]).to eq('template or to not passed')
  #   end
  # end

  # it 'errors that params not passed and list the missing params test #1' do
  #   payload = {
  #     'template' => 'SMSOTP_ru',
  #     'to' => '+95745732234',
  #     'params' => {}
  #   }
  #   message = Message.new(payload)
  #   begin
  #     message.template_render
  #   rescue LiquidTemplateMissing => e
  #     expect(e.message.first[:code]).to eq('params_missing')
  #     expect(e.message.first[:params]).to eq(['code'])
  #   end
  # end

  # it 'errors that params not passed and list the missing params test #2' do
  #   payload = {
  #     'template' => 'SMSDEBETMONEY_en',
  #     'to' => '+95745732234',
  #     'params' => {}
  #   }
  #   message = Message.new(payload)
  #   begin
  #     message.template_render
  #   rescue LiquidTemplateMissing => e
  #     expect(e.message.first[:code]).to eq('params_missing')
  #     expect(e.message.first[:params]).to eq(
  #       %w(
  #         date
  #         account_name
  #         amount
  #         operation_currency_alfa3
  #         balance
  #         account_currency_alfa3
  #       )
  #     )
  #   end
  # end
end
