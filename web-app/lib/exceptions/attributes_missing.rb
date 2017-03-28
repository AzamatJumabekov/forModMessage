# Error class for params missing 'template' or 'to'
class AttributesMissing < StandardError
  def self.message
    ['code': 'attributs missing', 'params': 'template or to not passed']
  end
end
