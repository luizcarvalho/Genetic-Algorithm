class Individuo
  attr_reader :code,:value,:id,:value_pro
  attr_accessor :proporcao
  @@global_id = 0

  #Construtor
  def initialize(code = nil)
    @code = code || ((0+rand(8_388_608)).to_s(base=2)).rjust(23,"0")
    @value = to_value(@code)
    @value_pro = 489 - @value #contrabalancear a maximização
    @id = "P#{@@global_id}"
    @@global_id+=1
  end

  #Determina o valor da função Objetivo do individuo
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
  def self.clean_populacao
    @@global_id = 0
  end
end
