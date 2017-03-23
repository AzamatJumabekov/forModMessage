TEMPLATES_PATH = ENV['RACK_ENV'] == 'test' ? './features/templates/' : './assets/templates/'

# This class is for working with template files
class AdminTemplate
  def initialize(params)
    @params = params
  end

  def self.templates_list
    Dir[TEMPLATES_PATH + '*'].select { |f| File.file? f }.map { |f| File.basename f }
  end

  def show
    File.read(TEMPLATES_PATH + @params['template'])
  end

  def delete
    File.delete(TEMPLATES_PATH + @params)
  end

  def update
    if @params['old_name'] != @params['name'] || @params['template_type'] != @params['old_name'].split('_')[0]
      File.rename(TEMPLATES_PATH + @params['old_name'], TEMPLATES_PATH + file_name)
    end
    write_to_file
  end

  def edit
    file = File.read(TEMPLATES_PATH + @params['template'])
    hash = JSON.parse(file)
    hash['message']
  end

  def create
    write_to_file
  end

  def give_file_name
    file_name
  end

  private

  def write_to_file
    File.open(TEMPLATES_PATH + file_name, 'w+') { |file| file.write(make_json) }
  end

  def make_json
    text = { 'message': @params['template_attributes'] }
    JSON.pretty_generate(text)
  end

  def file_name
    @params['template_type'] + '_' + @params['name'].upcase + '_' + @params['lang']
  end
end
