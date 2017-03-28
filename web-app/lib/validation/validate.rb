# This class is for validation logic
class Validate
  def self.params(payload)
    case payload
    when nil
      raise StandardError, 'nil params'
    when Hash
      payload
    else
      JSON.parse(payload)
    end
  end
end
