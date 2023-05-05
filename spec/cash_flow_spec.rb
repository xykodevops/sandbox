require 'rspec'
require 'rack/test'
require_relative '../cash_flow.rb'

set :environment, :test

describe 'Transaction' do
  it 'should initialize correctly' do
    t = Transaction.new(50, '2023-05-05', 'description')
    expect(t.amount).to eq 50
    expect(t.date).to eq '2023-05-05'
    expect(t.description).to eq 'description'
  end
end

describe 'Debit' do
  it 'should be a Transaction' do
    expect(Debit.new(50, '2023-05-05', 'description')).to be_a Transaction
  end
end

describe 'Credit' do
  it 'should be a Transaction' do
    expect(Credit.new(50, '2023-05-05', 'description')).to be_a Transaction
  end
end

describe 'Cashflow App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "should display the homepage" do
    get '/'
    expect(last_response).to be_ok
  end

  it "should display the summary page" do
    get '/summary'
    expect(last_response).to be_ok
  end

  it "should store a transaction and redirect to homepage" do
    post '/cashflow', params={amount: 50, description: 'description', type: 'C', date: '2023-05-05'}
    expect(last_response.redirect?).to be true
    follow_redirect!
    expect(last_request.path).to eq('/')
  end

  it "should display a day summary" do
    post '/cashflow', params={amount: 50, description: 'description', type: 'C', date: '2023-05-05'}
    get '/summary/2023-05-05'
    expect(last_response).to be_ok
  end
end