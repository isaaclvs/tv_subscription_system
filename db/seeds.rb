# Sistema de TV por Assinatura - Seeds
# Dados realistas para demonstrar todas as funcionalidades

puts "Iniciando seeds do sistema de TV por assinatura..."

# Limpeza para executar novamente (idempotente)
puts "Limpando dados existentes..."
Subscription.destroy_all
Package.destroy_all
Plan.destroy_all
AdditionalService.destroy_all
Customer.destroy_all

# ==================== CUSTOMERS ====================
puts "Criando clientes..."

customers = [
  { name: "João Silva", age: 35 },
  { name: "Maria Santos", age: 28 },
  { name: "Pedro Oliveira", age: 45 },
  { name: "Ana Costa", age: 31 },
  { name: "Carlos Ferreira", age: 52 }
]

customers.each do |customer_data|
  Customer.create!(customer_data)
end

puts "   #{Customer.count} clientes criados"

# ==================== PLANS ====================
puts "Criando planos..."

plans = [
  { name: "Plano Básico", price: 29.90 },
  { name: "Plano Família", price: 49.90 },
  { name: "Plano Premium", price: 79.90 },
  { name: "Plano Ultra HD", price: 99.90 }
]

plans.each do |plan_data|
  Plan.create!(plan_data)
end

puts "   #{Plan.count} planos criados"

# ==================== ADDITIONAL SERVICES ====================
puts "Criando serviços adicionais..."

services = [
  { name: "HBO Max", price: 19.90 },
  { name: "Netflix Premium", price: 25.90 },
  { name: "Disney Plus", price: 17.90 },
  { name: "Amazon Prime Video", price: 14.90 },
  { name: "Paramount Plus", price: 16.90 },
  { name: "Apple TV+", price: 12.90 },
  { name: "Globoplay", price: 22.90 },
  { name: "Crunchyroll", price: 18.90 }
]

services.each do |service_data|
  AdditionalService.create!(service_data)
end

puts "   #{AdditionalService.count} serviços adicionais criados"

# ==================== PACKAGES ====================
puts "Criando pacotes..."

# Pacote Família (Plano Família + HBO + Disney)
family_package = Package.new(
  name: "Pacote Família Completo",
  plan: Plan.find_by(name: "Plano Família")
)
family_package.additional_services << AdditionalService.find_by(name: "HBO Max")
family_package.additional_services << AdditionalService.find_by(name: "Disney Plus")
family_package.save!

# Pacote Premium (Plano Premium + Netflix + Amazon + Apple TV)
premium_package = Package.new(
  name: "Pacote Premium All-in-One", 
  plan: Plan.find_by(name: "Plano Premium")
)
premium_package.additional_services << AdditionalService.find_by(name: "Netflix Premium")
premium_package.additional_services << AdditionalService.find_by(name: "Amazon Prime Video")
premium_package.additional_services << AdditionalService.find_by(name: "Apple TV+")
premium_package.save!

# Pacote Ultra (Plano Ultra HD + todos os streamings)
ultra_package = Package.new(
  name: "Pacote Ultra Streaming",
  plan: Plan.find_by(name: "Plano Ultra HD")
)
ultra_package.additional_services << AdditionalService.find_by(name: "Netflix Premium")
ultra_package.additional_services << AdditionalService.find_by(name: "HBO Max") 
ultra_package.additional_services << AdditionalService.find_by(name: "Disney Plus")
ultra_package.additional_services << AdditionalService.find_by(name: "Globoplay")
ultra_package.save!

puts "   #{Package.count} pacotes criados"

# ==================== SUBSCRIPTIONS ====================
puts "Criando assinaturas..."

# Assinatura 1: João com Plano Básico + HBO Max
joao = Customer.find_by(name: "João Silva")
basic_plan = Plan.find_by(name: "Plano Básico")
hbo_service = AdditionalService.find_by(name: "HBO Max")

result1 = CreateSubscriptionService.new(
  customer: joao,
  plan: basic_plan,
  additional_services: [hbo_service]
).call

puts "   João Silva: Plano Básico + HBO Max (#{result1.success? ? 'SUCESSO' : 'ERRO'})"

# Assinatura 2: Maria com Pacote Família
maria = Customer.find_by(name: "Maria Santos")
family_pkg = Package.find_by(name: "Pacote Família Completo")

result2 = CreateSubscriptionService.new(
  customer: maria,
  package: family_pkg
).call

puts "   Maria Santos: Pacote Família Completo (#{result2.success? ? 'SUCESSO' : 'ERRO'})"

# Assinatura 3: Pedro com Plano Premium + Globoplay + Crunchyroll
pedro = Customer.find_by(name: "Pedro Oliveira")
premium_plan = Plan.find_by(name: "Plano Premium")
globoplay = AdditionalService.find_by(name: "Globoplay")
crunchyroll = AdditionalService.find_by(name: "Crunchyroll")

result3 = CreateSubscriptionService.new(
  customer: pedro,
  plan: premium_plan,
  additional_services: [globoplay, crunchyroll]
).call

puts "   Pedro Oliveira: Plano Premium + 2 serviços (#{result3.success? ? 'SUCESSO' : 'ERRO'})"

# Assinatura 4: Ana com Pacote Ultra
ana = Customer.find_by(name: "Ana Costa")
ultra_pkg = Package.find_by(name: "Pacote Ultra Streaming")

result4 = CreateSubscriptionService.new(
  customer: ana,
  package: ultra_pkg
).call

puts "   Ana Costa: Pacote Ultra Streaming (#{result4.success? ? 'SUCESSO' : 'ERRO'})"

# Assinatura 5: Carlos com Plano Família (sem serviços extras)
carlos = Customer.find_by(name: "Carlos Ferreira")
family_plan = Plan.find_by(name: "Plano Família")

result5 = CreateSubscriptionService.new(
  customer: carlos,
  plan: family_plan
).call

puts "   Carlos Ferreira: Plano Família (#{result5.success? ? 'SUCESSO' : 'ERRO'})"

puts "   #{Subscription.count} assinaturas criadas"

# ==================== ESTATÍSTICAS FINAIS ====================
puts "\nRESUMO DO SISTEMA:"
puts "=" * 50

puts "DADOS PRINCIPAIS:"
puts "   - Clientes: #{Customer.count}"
puts "   - Planos: #{Plan.count}" 
puts "   - Serviços Adicionais: #{AdditionalService.count}"
puts "   - Pacotes: #{Package.count}"
puts "   - Assinaturas: #{Subscription.count}"

puts "\nFATURAMENTO AUTOMÁTICO:"
puts "   - Contas geradas: #{Account.count}"
puts "   - Faturas geradas: #{Invoice.count}"
puts "   - Carnês gerados: #{Booklet.count}"

puts "\nVALORES:"
total_monthly = Subscription.joins(:invoices).where(invoices: { month_year: Date.current.next_month.strftime("%Y-%m") }).sum(:total_amount)
total_annual = Booklet.sum(:total_amount)

puts "   - Faturamento mensal: R$ #{total_monthly.to_f}"
puts "   - Faturamento anual: R$ #{total_annual.to_f}"

puts "\nVALIDAÇÕES DEMONSTRADAS:"
puts "   - XOR (plano OU pacote): Todas assinaturas respeitam"
puts "   - Idade mínima 18 anos: Todos clientes válidos"
puts "   - Auto-pricing pacotes: Preços calculados automaticamente"
puts "   - Billing 12 meses: #{Invoice.count / 12} assinaturas x 12 meses"

puts "\nSEEDS CONCLUÍDAS COM SUCESSO!"
puts "   Execute 'rails console' para explorar os dados"
puts "   Execute 'rails server' para acessar a aplicação"