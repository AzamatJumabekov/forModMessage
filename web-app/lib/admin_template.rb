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
    if @params['old_name'] != @params['name'] || @params['template_type'] != @params['old_name'].split('_')[0]
      File.rename("./assets/templates/" + @params['old_name'], "./assets/templates/" + file_name)
    end
    write_to_file
  end

  def edit
    file = File.read('./assets/templates/' + @params['template'])
  end

  def create
    write_to_file
  end

  private
  def write_to_file
    File.open("./assets/templates/" + file_name, "w+") { |file| file.write(@params['template_attributes']) }
  end

  def file_name
    @params['template_type'] + "_" + @params['name'].upcase + "_" + @params['lang']
  end

end