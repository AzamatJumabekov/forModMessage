# Error class for missing additional params
class LiquidTemplateMissing < StandardError
  def initialize(params)
    @params = params
  end

  def message
    error = (@params.map { |e| e.message[/Liquid error: undefined variable (.+)/, 1] }).uniq
    ['code': 'params_missing', 'params': error]
  end
end
