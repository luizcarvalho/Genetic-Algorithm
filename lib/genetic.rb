require 'individuo'
require 'selecao'


class Raca

  attr_reader :populacao,:quantidade,:populacao_ordenada,:selecionaveis
  attr_accessor :valor_total,:geracao
  @@incumbentes = {}
  @@geracao = 1
  @@operador_de_mutacao = 5 #% de 10000 = 0,05 de 100

  def initialize(quantidade)
    @quantidade = quantidade
    @selecionaveis = quantidade/2
    @populacao = criar_populacao(@quantidade)
    nova_era
  end


  def criar_populacao(quantidade)
    Individuo.clean_populacao
    quantidade.times.collect{Individuo.new}
  end

  def get_incumbente
    @populacao.collect { |ind| [ind.value,"<#{ind.id.ljust(5)} (#{ind.value})".ljust(6)+": [#{ind.code}]"] }.sort.first[1]
  end

  def nova_era
    @@incumbentes[@@geracao]= get_incumbente #pega-se o valor da era anterior
    @@geracao+=1 #inicia nova geração
  end

  def armagedom
    @quantidade = 0 #zera quantidade de individuos
    @populacao = [] #destroi a populacao
  end


  def to_s
    out =  "ID:".ljust(7)+"Valor".ljust(10)+"     Código Genético ".ljust(25)+"\n\n"
    @populacao.each do |individuo|
      out << "P#{individuo.id.ljust(6)} #{individuo.value.to_s.ljust(10)} #{individuo.code.ljust(25)}\n"
    end
    out
  end

  def cruzamento=(individuos)
    armagedom
    i=0
    
    while i< @selecionaveis
      cut = 1+rand(23)      

      a = individuos[i].clone;
      i+=1;
      b = individuos[i].clone;
      ax = a.code[0,cut];
      ay = a.code[cut,23];
      bx = b.code[0,cut];
      by = b.code[cut,23]; 
      c = Individuo.new(mutacao(ax+by));
      d = Individuo.new(mutacao(bx+ay));

      i+=1
      @populacao = @populacao+[a,b,c,d]
      @quantidade = @quantidade+=4
    end
    nova_era
  end
def mutacao(code)
  new_code = code.clone
  
  gene_x  = 0+rand(1000);
  if (@@operador_de_mutacao == gene_x)
    cross_x = 0+rand(23)
    new_code.slice!(cross_x)
    new_code = new_code.insert(cross_x,(code[cross_x,1] == "0" ? "1":"0"))
  end  
end
  
  def self.resultado
    puts "Total de Gerações: #{@@geracao-1}"
    puts "=== Chances de correr mutação: #{@@operador_de_mutacao*0.001}%"
    puts "Melhores Individuos por geração:"
    @@incumbentes.keys.sort.each{ |key| puts "#{key}º geração".ljust(15)+" => #{@@incumbentes[key]}" }
  end
  
  
end


anfibios = Raca.new(256) #128/64 - 16/8
100.times do #considere +1 por existe a população inicial
  individuos_selecionados = selecao_proporcional(anfibios) #população e quantos descendentes são necessários
  anfibios.cruzamento=(individuos_selecionados)
end

Raca.resultado
