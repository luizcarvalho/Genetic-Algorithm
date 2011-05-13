require 'individuo'
class Raca

  attr_reader :populacao,:quantidade,:populacao_ordenada
  attr_accessor :valor_total
  
  def initialize(quantidade)
    @quantidade = quantidade
    @populacao = criar_populacao(@quantidade)
  end
  
  def criar_populacao(quantidade)
      quantidade.times.collect{Individuo.new}
  end

  def selecao_natural
    @populacao.collect { |ind| [ind.value,ind.code] }.sort
  end

  def to_s
    out =  "Valor".ljust(10)+"     Código Genético ".ljust(25)+"\n\n"
    @populacao.each do |individuo|
    out << "#{individuo.value.to_s.ljust(10)} #{individuo.code.ljust(25)}\n"
    end
    out
  end



  
  
end

anfibios = Raca.new(12)
puts anfibios