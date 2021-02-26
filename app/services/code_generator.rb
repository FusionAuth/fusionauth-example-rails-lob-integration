class CodeGenerator

  def initialize()
  end

  def code
    ary = [('0'..'9').to_a, ('a'..'z').to_a, ('A'..'Z').to_a].flatten

    # confusing
    ary.delete('0')
    ary.delete('O')
    ary.delete('l')
    ary.delete('1')
   
    ary.sample(8).join('')
  end
end


