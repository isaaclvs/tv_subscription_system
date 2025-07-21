# Sistema de TV por Assinatura

Sistema completo de gerenciamento de assinaturas de TV desenvolvido em Rails seguindo as melhores práticas de arquitetura e qualidade de código.

## Características Principais

- **Validação XOR**: Cliente deve ter plano OU pacote, nunca ambos
- **Auto-pricing**: Pacotes calculam preço automaticamente (plano + serviços)
- **Faturamento Automático**: 12 meses gerados na criação da assinatura
- **Validações Complexas**: Regras de negócio rigorosamente implementadas
- **Service Objects**: Lógica complexa isolada em services
- **Cobertura de Testes**: 88%+ com RSpec

## Arquitetura

### Models
- `Customer`: Clientes (18+ anos)
- `Plan`: Planos base
- `AdditionalService`: Serviços extras
- `Package`: Pacotes (plano + serviços)
- `Subscription`: Assinaturas com validações XOR
- `Account`, `Invoice`, `Booklet`: Sistema de billing

### Service Objects
- `CreateSubscriptionService`: Orquestra criação + validações
- `BillingService`: Gera faturamento de 12 meses automático

### Validações Críticas
1. **XOR**: Assinatura com plano OU pacote (constraint no DB)
2. **Idade**: Apenas clientes 18+
3. **Serviços únicos**: Sem duplicatas na assinatura
4. **Conflito de pacote**: Não pode adicionar serviço já presente no pacote
5. **Auto-pricing**: Pacotes sem preço = soma(plano + serviços)

## Setup Rápido

```bash
# Clone o repositório
git clone https://github.com/isaaclvs/tv_subscription_system.git
cd tv_subscription_system

# Instale dependências
bundle install

# Configure o banco
rails db:create
rails db:migrate
rails db:seed

# Execute os testes
rspec

# Inicie o servidor
rails server
```

Acesse: http://localhost:3000

## Estrutura do Banco

```sql
-- Core entities
customers (name, age)
plans (name, price)
additional_services (name, price)
packages (name, plan_id, price)

-- Relationships
package_services (package_id, additional_service_id)
subscriptions (customer_id, plan_id, package_id) -- XOR constraint
subscription_services (subscription_id, additional_service_id)

-- Billing system
accounts (subscription_id, item_type, item_id, amount, due_date)
invoices (subscription_id, month_year, total_amount, due_date)
booklets (subscription_id, total_amount)
```

## Regras de Negócio

### Clientes
- Nome obrigatório
- Idade mínima 18 anos

### Planos
- Nome e preço obrigatórios
- Preço > 0

### Serviços Adicionais
- Nome e preço obrigatórios
- Preço > 0

### Pacotes
- Nome obrigatório
- Deve ter ao menos um serviço adicional
- Preço calculado automaticamente se não informado
- Não pode duplicar serviços

### Assinaturas
- Deve ter plano OU pacote (nunca ambos)
- Serviços adicionais são opcionais
- Não pode repetir o mesmo serviço
- Se usa pacote, não pode adicionar serviços já inclusos

### Faturamento
- Gerado automaticamente na criação da assinatura
- 12 meses subsequentes ao mês de criação
- Vencimento no mesmo dia da assinatura
- Uma conta por item (plano/pacote + cada serviço)
- Uma fatura por mês (agrupa todas as contas)
- Um carnê por assinatura (agrupa 12 faturas)

## Dados de Exemplo

Execute `rails db:seed` para popular com:
- 5 clientes
- 4 planos
- 8 serviços adicionais (Netflix, HBO, Disney+, etc.)
- 3 pacotes com auto-pricing
- 5 assinaturas demonstrando todas as funcionalidades
- 60 contas + 60 faturas + 5 carnês (billing completo)

## Testes

```bash
# Execute todos os testes
rspec

# Execute com cobertura
rspec --format html

# Apenas models
rspec spec/models/

# Apenas services
rspec spec/services/
```

## Status dos Testes

Segue exemplo da saída atual dos testes RSpec:

```bash
$ rspec
92 examples, 0 failures, 9 pending

Coverage report generated for RSpec to coverage/.
Line Coverage: 88.08% (340 / 386)
```

## Demonstração das Funcionalidades

### Via Web Interface
- `/`: Dashboard com estatísticas
- `/customers`: Lista de clientes
- `/subscriptions`: Lista de assinaturas detalhadas

### Via Rails Console
```ruby
# Criar assinatura válida
customer = Customer.first
plan = Plan.first
service = CreateSubscriptionService.new(
  customer: customer, 
  plan: plan,
  additional_services: [AdditionalService.first]
).call

# Verificar billing automático
service.subscription.invoices.count # => 12
service.subscription.accounts.count  # => 12 (plan + service)
service.subscription.booklet.total_amount # => valor anual

# Testar validações
invalid = CreateSubscriptionService.new(
  customer: customer,
  plan: plan,
  package: Package.first  # ERRO: não pode ter ambos
).call
invalid.success? # => false
invalid.errors   # => ["Cannot have both plan and package"]
```

---

**Desenvolvido com qualidade técnica, seguindo as melhores práticas de Rails e arquitetura limpa.**

