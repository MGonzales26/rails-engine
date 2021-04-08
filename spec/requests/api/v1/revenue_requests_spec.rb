require 'rails_helper'

RSpec.describe "revenue api" do
  describe "total revenue by date range" do
    describe "happy path" do
      it "gives the total revenue of the whole system given a date range" do
        merchant_1 = create(:merchant)
        item_1 = create(:item, merchant: merchant_1)
        invoice_1 = create(:invoice, merchant: merchant_1, created_at: '2021-04-07',)
        invoice_2 = create(:invoice, merchant: merchant_1, created_at: '2020-04-07')
        transaction_1 = create(:transaction, invoice: invoice_1, result: 'success')
        transaction_2 = create(:transaction, invoice: invoice_2, result: 'success')

        invoice_item_1 = create(:invoice_item, quantity: 1, unit_price: 10, item: item_1, invoice: invoice_1)
        invoice_item_2 = create(:invoice_item, quantity: 1, unit_price: 5, item: item_1, invoice: invoice_2)
        #year-month-day
        get "/api/v1/revenue?start=2021-04-01&end=2021-04-08"
        expect(response).to be_successful
        
        result = JSON.parse(response.body, symbolize_names: true)

        expect(result).to be_a(Hash)
        expect(result).to have_key(:data)
        expect(result[:data]).to be_a(Hash)
        expect(result[:data]).to have_key(:id)
        expect(result[:data][:id]).to eq(nil)
        expect(result[:data]).to have_key(:type)
        expect(result[:data]).to have_key(:attributes)
        expect(result[:data][:attributes]).to be_a(Hash)
        expect(result[:data][:attributes]).to have_key(:revenue)
        expect(result[:data][:attributes][:revenue]).to eq(10.0)
        expect(result[:data][:attributes][:revenue]).to_not eq(15.0)
        expect(result[:data][:attributes][:revenue]).to_not eq(5.0)
      end
    end
  end

  describe "weekly revenue" do
    describe "happy path" do
      it "returns the weekly revenue" do
        merchant_1 = create(:merchant)
        item_1 = create(:item, merchant: merchant_1)
        invoice_1 = create(:invoice, merchant: merchant_1, created_at: '2021-04-05', status: 'shipped')
        invoice_2 = create(:invoice, merchant: merchant_1, created_at: '2020-04-12', status: 'shipped')
        invoice_3 = create(:invoice, merchant: merchant_1, created_at: '2020-04-19', status: 'shipped')
        invoice_4 = create(:invoice, merchant: merchant_1, created_at: '2020-04-26', status: 'shipped')

        transaction_1 = create(:transaction, invoice: invoice_1, result: 'success')
        transaction_2 = create(:transaction, invoice: invoice_2, result: 'success')
        transaction_3 = create(:transaction, invoice: invoice_3, result: 'success')
        transaction_4 = create(:transaction, invoice: invoice_4, result: 'success')

        invoice_item_1 = create(:invoice_item, quantity: 1, unit_price: 10, item: item_1, invoice: invoice_1)
        invoice_item_2 = create(:invoice_item, quantity: 1, unit_price: 5, item: item_1, invoice: invoice_2)
        invoice_item_3 = create(:invoice_item, quantity: 1, unit_price: 10, item: item_1, invoice: invoice_3)
        invoice_item_4 = create(:invoice_item, quantity: 1, unit_price: 5, item: item_1, invoice: invoice_4)
        
        # get '/api/v1/revenue/weekly'
        # expect(response).to be_successful
    
        # require 'pry'; binding.pry
        # weeks = JSON.parse(response.body, symbolize_names: true)
        # expect(weeks).to be_a(Hash)
        # expect(weeks).to have_key(:data)
        # expect(weeks[:data]).to be_an(Array)
        # expect(weeks[:data].count).to eq(4)
        # require 'pry'; binding.pry
      end
    end
  end
end