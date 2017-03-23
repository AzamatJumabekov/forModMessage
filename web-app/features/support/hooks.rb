Before do
  FileUtils.rm_r Dir.glob('features/templates/*')
  FileUtils.cp_r 'features/templates_for_test/.', 'features/templates/.'
end
