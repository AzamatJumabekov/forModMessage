# Adding colors to string class
class String
  def magenta
    "\e[35m#{self}\e[0m"
  end

  def cyan
    "\e[36m#{self}\e[0m"
  end

  def white
    "\e[37m#{self}\e[1m"
  end
end
