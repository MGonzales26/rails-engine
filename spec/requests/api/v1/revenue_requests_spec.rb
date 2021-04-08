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
end