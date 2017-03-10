RSpec.describe Message do
  it 'should return rendered text from template' do
    payload = {"template" => "SMSOTP_ru", "to" => "+95745732234", "params" => {"code" => "4353"}}
    message = Message.new(payload)
    expect(message.template_render).to eq("OpenWallet. Код подтверждения - 4353. Никому не сообщайте этот код.")
  end

  it 'should return error with code "attributes missing" and text "template or to not passed"' do
    payload = {}
    message = Message.new(payload)
    begin
      message.template_render
    rescue AttributesMissing => e
      expect(e.message.first[:code]).to eq('attributs missing')
      expect(e.message.first[:params]).to eq('template or to not passed')
    end
  end

  it 'errors that params not passed and list the missing params test #1' do
    payload = {"template" => "SMSOTP_ru", "to" => "+95745732234", "params" => {}}
    message = Message.new(payload)
    begin
      message.template_render
    rescue LiquidTemplateMissing => e
      expect(e.message.first[:code]).to eq('params_missing')
      expect(e.message.first[:params]).to eq(["code"])
    end
  end

  it 'errors that params not passed and list the missing params test #2' do
    payload = {"template" => "SMSDEBETMONEY_en", "to" => "+95745732234", "params" => {}}
    message = Message.new(payload)
    begin
      message.template_render
    rescue LiquidTemplateMissing => e
      expect(e.message.first[:code]).to eq('params_missing')
      expect(e.message.first[:params]).to eq(["date", "account_name", "amount", "operation_currency_alfa3", "balance", "account_currency_alfa3"])
    end
  end

end
