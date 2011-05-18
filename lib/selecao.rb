
def selecao_proporcional(raca)
  roleta = gerar_circulo(raca)
  puts "\n\n  ------------------  DRAW ROLETA   --------------------"
  roleta_tos(roleta)
  puts "\n\n  --------------- ROLAR ROLETA ----------------- "
  raca.selecionaveis.times.collect { girar(roleta) }
end



def gerar_circulo(raca)
  @n = Float(raca.quantidade) ;puts "N(quantidade de individuos): #{@n}"
  @total = extract_total(raca.populacao);puts "Valor total dos individuos: #{@total}"
  @zmx = @total/@n; puts "ZMX (Média da Função Objetivo): #{@zmx}"
  @grau_total = 360 #Permite que individuos de até 2 casas decimais participem da seleção, os demais serão descartados
  #por ordem natural da roleta
  puts "Grau total: #{@grau_total}"
  @grau_parcial = 0; puts "Grau parcial inicia-se com 0"
  @circulo_trigonometrico = {}
  puts "\n\n+ Calculos.....\n\n"
  raca.populacao.each do |individuo|
    puts "== #{individuo.id}   =========="
    @ndi = individuo.value_pro/@zmx; puts "NDI: Numero de descendentes:".ljust(30)+"(#{individuo.value_pro}/#{@zmx}) = #{@ndi} "
    init_range = @grau_parcial
    grau_individual = @grau_total*(@ndi/@n); puts "Grau Individual:".ljust(30)+"#{grau_individual}"
    puts "VALOR".ljust(30)+"#{individuo.value}"
    @grau_parcial = @grau_parcial + grau_individual; puts "Grau alcançado: ".ljust(30)+" #{@grau_parcial}"
    @circulo_trigonometrico[@grau_parcial] = individuo; puts "RANGE: ".ljust(30)+"#{init_range} - #{@grau_parcial}\n\n"

  end
    
  @circulo_trigonometrico
end


def girar(roleta)
    
  roll = 0.0+rand(@grau_total*10000)*0.0001; puts "\n\n Valor do Dado: #{roll}"
    
  roleta.keys.sort.each do |grau|
    unless grau < roll
      puts "ROLETA PAROU EM: #{roleta[grau]} com GRAU: #{grau}" unless grau < roll
      return roleta[grau] unless grau < roll #retorna um individuo
    end
  end
    
end

def roleta_tos(roleta)
  roleta.keys.sort.each {|grau| puts "#{roleta[grau].id.ljust(6)} => #{grau} - (#{roleta[grau].value})" }
end

  
def extract_total(populacao)
  total = 0
  populacao.each do |individuo|
    total += individuo.value_pro
  end
  total
end
