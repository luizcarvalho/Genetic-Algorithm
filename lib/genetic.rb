require 'individuo'
require 'selecao'


class Raca

  attr_reader :populacao,:quantidade,:populacao_ordenada,:selecionaveis
  attr_accessor :valor_total,:geracao
  @@incumbentes = {}
  @@geracao = 1
  @@operador_de_mutacao = 5 #% de 10000 = 0,05 de 100
  @@mutacoes= 0
  @@cruzamentos = 0


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
    @populacao.collect { |ind| [ind.value,"<#{ind.id} (#{ind.value}): [#{ind.code}]"] }.sort.first[1]
  end

  def nova_era
    puts "\n\n\n\n\n++++++++ FIM DA #{@@geracao}º GERAÇÃO +++++++++++++++++++"

    @@incumbentes[@@geracao]= get_incumbente #pega-se o valor da era anterior
    puts "=== INCUMBENTE: #{@@incumbentes[@@geracao]}"
    puts "=== QUANTIDADE: #{@quantidade}"
    puts "=== POPULACAO ===================================================="
    puts to_s
    @@geracao+=1 #inicia nova geração
    puts "==================================================================\n\n"
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
    puts "\n\n -------------- Cruzamento  ----------  "
    
    while i< @selecionaveis
      cut = 1+rand(23)      
      puts "\n\nPOSIÇÃO DO CORTE: #{cut}"
      a = individuos[i].clone; print "#{a} "
      i+=1;
      b = individuos[i].clone; print "X #{b})\n"
      ax = a.code[0,cut]; puts "#{a.id}(X): #{ax}"
      ay = a.code[cut,23]; puts "#{a.id}(Y): #{ay}"
      bx = b.code[0,cut]; puts "#{b.id}(X): #{bx}"
      by = b.code[cut,23]; puts "#{b.id}(Y): #{by}"
      c = Individuo.new(mutacao(ax+by)); puts "NOVO INDIVIDUO #{a.id}(X)+#{b.id}(Y): #{c}"
      d = Individuo.new(mutacao(bx+ay)); puts "NOVO INDIVIDUO #{b.id}X+#{a.id}Y: #{d}"

      i+=1
      @populacao = @populacao+[a,b,c,d]
      @quantidade = @quantidade+=4
      @@cruzamentos = @@cruzamentos+=1
    end
    nova_era
  end
def mutacao(code)
  new_code = code.clone
  
  gene_x  = 0+rand(10000); puts "GENE X: #{gene_x}"
  if (@@operador_de_mutacao == gene_x)

    puts "############## DANGER! DANGER!: MUTAÇÃO NA POPULACAO ############"
    puts "Código genético original: #{code}"
    cross_x = 0+rand(23)
    puts "gene afetado: #{cross_x}"
    new_code.slice!(cross_x)
    new_code = new_code.insert(cross_x,(code[cross_x,1] == "0" ? "1":"0"))
    @@mutacoes+=1
    puts "Código Mutante: #{new_code}"
  end  
end
  
  def self.resultado
    puts "Total de Gerações: #{@@geracao-1}"
    puts "=== Operador de mutações: #{@@operador_de_mutacao}"
    puts "=== Mutações: #{@@mutacoes}"
    puts "=== Cruzamentos: #{@@cruzamentos}"
    puts "Melhores Individuos por geração:"
    @@incumbentes.keys.sort.each{ |key| puts "#{key}º geração".ljust(15)+" => #{@@incumbentes[key]}" }
  end
  
  
end


anfibios = Raca.new(16) #128/64 - 16/8
10.times do
  individuos_selecionados = selecao_proporcional(anfibios) #população e quantos descendentes são necessários
  anfibios.cruzamento=(individuos_selecionados)
end

Raca.resultado
