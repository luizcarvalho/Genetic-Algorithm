class Individuo
  attr_reader :code,:value
  attr_accessor :proporcao
  
  def initialize
    @code = ((0+rand(8_388_608)).to_s(base=2)).rjust(23,"0")
    @value = to_value(@code)
  end

  def to_value(binary)
    a = [10,20,30,11,25,23,32,9,7,19,17,31,48,27,5,21,35,13,38,16,14,33,5]
    sign = {"0"=>-1,"1"=>1}
    value = index = 0
    binary.each_char do |c|
      value = value+a[index]*sign[c]
      index+=1
    end
    (value<0 ? value*-1:value ) #MODULO
  end
end
