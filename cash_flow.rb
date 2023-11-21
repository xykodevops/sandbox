# frozen_string_literal: true


# Program: Cash_flow
# Date:    06/05/23'
# Author:  Xyko
# Email:   xykodevops@gmail.com
require 'sinatra'
require 'yaml/store'
require 'yaml'

set :bind, '0.0.0.0'
set :port, 8080

TRANSACTION_TYPE = {
  'D' => 'Debit',
  'C' => 'Credit'
}.freeze

# Classe base para transações financeiras.
class Transaction
  # Valor da transação
  attr_accessor :amount

  # Data da transação
  attr_accessor :date

  # Descrição da transação
  attr_accessor :description

  # Inicializa uma nova instância da classe Transaction
  #
  # @param amount [Numeric] valor da transação
  # @param date [Date] data da transação
  # @param description [String] descrição da transação
  def initialize(amount, date, description)
    @amount = amount
    @date = date
    @description = description
  end
end

# Representa uma transação de débito financeiro
class Debit < Transaction
end

# Representa uma transação de crédito financeiro
class Credit < Transaction
end

get '/' do
  erb :index
end

store = YAML::Store.new('transactions.yml')

post '/cashflow' do
  amount = params['amount']
  description = params['description']
  type = params['type']
  date = params['date']

  # Armazena a transação no arquivo YAML
  store.transaction do
    store['transactions'] ||= []
    store['transactions'] << {
      amount:,
      description:,
      type:,
      date:
    }
  end

  # Redireciona para a página inicial
  redirect '/'
end

get '/summary' do
  data = YAML.load_file('transactions.yml')
  transactions = data['transactions']

  summary = {}
  transactions.each do |t|
    date = DateTime.parse(t[:date]).strftime('%Y-%m-%d')
    # if summary[date].nil?
    #   summary[date] = { credit: 0, debit: 0 }
    # end
    summary[date] = { credit: 0, debit: 0 } if summary[date].nil?
    if t[:type] == 'C'
      summary[date][:credit] += t[:amount].to_i
    else
      summary[date][:debit] += t[:amount].to_i
    end
  end

  erb :summary, locals: { summary: }
end

get '/summary/:date' do
  @transactions = YAML.load_file('transactions.yml')['transactions'].select { |t| t[:date] == params[:date] }
  erb :day_summary
end
