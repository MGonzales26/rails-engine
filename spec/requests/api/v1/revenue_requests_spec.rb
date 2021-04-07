require 'rails_helper'

RSpec.describe "revenue api" do
  describe "total revenue by date range" do
    describe "happy path" do
      it "gives the total revenue of the whole system given a date range" do
        merchant_1 = create(:merchant)
        item_1 = create(:item, merchant: merchant_1)
        invoice_1 = create(:invoice, merchant: merchant_1)

        invoice_item_1 = create(:invoice_item, quantity: 1, unit_price: 10, created_at: '2021-04-07', item: item_1, invoice: invoice_1)
        invoice_item_2 = create(:invoice_item, quantity: 1, unit_price: 5, created_at: '2020-04-07', item: item_1, invoice: invoice_1)
        #year-month-day
        get "/api/v1/revenue?start=2021-04-01&end=2021-04-08"
        expect(response). to be_successful

        expect(response).to be_a(Hash)
        expect(response).to have_key(:properties)
        expect(response[:properties]).to be_a(Hash)
        expect(response[:properties]).to have_key(:data)
        expect(response[:properties][:data]).to have_key(:properties)
        expect(response[:properties][:data][:properties]).to be_a(Hash)
        expect(response[:properties][:data][:properties]).to have_key(:attributes)
        expect(response[:properties][:data][:properties][:attributes]).to be_a(Hash)
        expect(response[:properties][:data][:properties][:attributes]).to have_key(:properties)
        expect(response[:properties][:data][:properties][:attributes][:properties]).to be_a(Hash)
        expect(response[:properties][:data][:properties][:attributes][:properties]).to have_key(:revenue)
      end
    end
  end
end