RSpec.describe AdminTemplate do
  params_ru = {"template"=>"SMS_OTP_RU"}
  params_kz = {"template"=>"SMS_OTP_KZ"}
  
  payload_kz = {"name"=>"OTP",
                "lang"=>"KZ",
                "template_type"=>"SMS",
                "template_attributes"=>"OpenWallet. Код подтверждения - {{code}}. Никому не сообщайте этот код."
  }

  before(:each) do
    FileUtils.rm_r Dir.glob('spec/templates/*')
    FileUtils.cp_r 'spec/templates_for_test/.', 'spec/templates/.'
  end

  it 'Достает шаблоны из папки ./rspec/templates/, метод templates_list' do
    @templates = AdminTemplate.templates_list
    expect(@templates).to eq(["EMAIL_OTP_RU", "SMS_OTP_RU", "SMS_OTP_EN"])
  end

  it 'Просматривает содержимое шаблона SMS_OTP_RU, метод show' do
    file = AdminTemplate.new(params_ru)
    expect(file.show).to eq("{\n  \"message\": \"OpenWallet. Код подтверждения - {{code}}. Никому не сообщайте этот код.\"\n}")
  end

  it 'Удаляет шаблон SMS_OTP_RU, метод delete' do
    template = AdminTemplate.new(params_ru['template'])
    template.delete
    expect(AdminTemplate.templates_list).to eq(["EMAIL_OTP_RU", "SMS_OTP_EN"])
  end

  it 'Сохраняет изменения шаблона(название шаблона с SMS_OTP_RU на SMS_OTP_KZ), метод update' do
    payload_kz.store("old_name", "SMS_OTP_RU")
    edited_file = AdminTemplate.new(payload_kz)
    edited_file.update
    expect(AdminTemplate.templates_list).to eq(["EMAIL_OTP_RU", "SMS_OTP_KZ", "SMS_OTP_EN"])
  end

  it 'Сохраняет изменение содержимого шаблона, метод update' do
    payload_kz.store("old_name", "SMS_OTP_RU")
    payload_kz['template_attributes'] = "Код подтверждения - {{code}}. Никому не сообщайте этот код."
    edited_file = AdminTemplate.new(payload_kz)
    edited_file.update
    file = AdminTemplate.new(params_kz)
    expect(file.show).to eq("{\n  \"message\": \"Код подтверждения - {{code}}. Никому не сообщайте этот код.\"\n}")
  end

  it 'Проверяет полученное содержимое шаблона на редактирование SMS_OTP_RU, метод edit' do
    file = AdminTemplate.new(params_ru)
    expect(file.edit).to eq("OpenWallet. Код подтверждения - {{code}}. Никому не сообщайте этот код.")
  end

  it 'Создаёт и просматривает новый шаблон SMS_OTP_KZ, метод create' do
    payload_kz['template_attributes'] = "OpenWallet. Растау коды - {{code}}. Бұл кодты ешкімге айтпаңыз."
    new_template = AdminTemplate.new(payload_kz).create
    template = AdminTemplate.new(params_kz)
    expect(template.show).to eq("{\n  \"message\": \"OpenWallet. Растау коды - {{code}}. Бұл кодты ешкімге айтпаңыз.\"\n}")
  end

  it 'Дает имя файла(шаблона), метод give_file_name' do
    file = AdminTemplate.new(payload_kz)
    expect(file.give_file_name).to eq("SMS_OTP_KZ")
  end
end
