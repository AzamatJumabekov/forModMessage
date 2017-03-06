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