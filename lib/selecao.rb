
def selecao_proporcional(raca)
  roleta = gerar_circulo(raca)
  raca.selecionaveis.times.collect { girar(roleta) }
end



def gerar_circulo(raca)
  @n = Float(raca.quantidade) 
  @total = extract_total(raca.populacao)
  @zmx = @total/@n
  @grau_total = 360
  @grau_parcial = 0
  @circulo_trigonometrico = {}

  raca.populacao.each do |individuo|
    @ndi = individuo.value_pro/@zmx
    init_range = @grau_parcial
    grau_individual = @grau_total*(@ndi/@n)
    @grau_parcial = @grau_parcial + grau_individual
    @circulo_trigonometrico[@grau_parcial] = individuo
  end    
  @circulo_trigonometrico
end


def girar(roleta)    
  roll = 0.0+rand(@grau_total*10000)*0.0001;    
  roleta.keys.sort.each do |grau|
    unless grau < roll
      return roleta[grau] unless grau < roll #retorna um individuo
    end
  end
    
end
  
def extract_total(populacao)
  total = 0
  populacao.each do |individuo|
    total += individuo.value_pro
  end
  total
end
