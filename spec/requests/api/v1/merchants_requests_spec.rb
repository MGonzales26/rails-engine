require 'rails_helper'

RSpec.describe "Merchants API" do
  describe "All Merchants" do
    describe "happy path" do
      it "gets all merchants limited to 20 unless optional query params passed" do
        create_list(:merchant, 50)
    
        get '/api/v1/merchants'
    
        expect(response).to be_success
    
        merchants = JSON.parse(response.body, symbolize_names: true)
    
        expect(merchants[:data].count).to eq(20)
    
        get '/api/v1/merchants?per_page=45'
    
        expect(response).to be_success
    
        merchants = JSON.parse(response.body, symbolize_names: true)
    
        expect(merchants[:data].count).to eq(45)
      end
    
      it "gets all merchants limited to 20 unless optional query params passed including page numbers" do
        merchant_1 = create(:merchant)
        merchant_2 = create(:merchant)
        merchant_3 = create(:merchant)
        merchant_4 = create(:merchant)
        merchant_5 = create(:merchant)
        merchant_6 = create(:merchant)
        merchant_7 = create(:merchant)
        merchant_8 = create(:merchant)
        merchant_9 = create(:merchant)
        merchant_10 = create(:merchant)
    
        get '/api/v1/merchants?per_page=8'
    
        expect(response).to be_success
    
        merchants = JSON.parse(response.body, symbolize_names: true)
        expect(merchants[:data].count).to eq(8)
    
        get '/api/v1/merchants?per_page=5&page=2'
    
        expect(response).to be_success
    
        merchants = JSON.parse(response.body, symbolize_names: true)
    
        expect(merchants).to be_a(Hash)
        expect(merchants).to have_key(:data)
        expect(merchants[:data]).to be_an(Array)
        expect(merchants[:data][0]).to have_key(:id)
        expect(merchants[:data][0][:id].to_i).to eq(merchant_6.id)
        expect(merchants[:data][0]).to have_key(:type)
        expect(merchants[:data][0][:type]).to eq("merchant")
        expect(merchants[:data][0]).to have_key(:attributes)
        expect(merchants[:data][0][:attributes][:name]).to eq(merchant_6.name)
        expect(merchants[:data][4][:id].to_i).to eq(merchant_10.id)
      end
    end

    describe "sad path" do
      it 'returns an empty array if there is no merchant' do
        get '/api/v1/merchants'
    
        expect(response).to be_success
    
        merchants = JSON.parse(response.body, symbolize_names: true)
        
        expected = []

        # expect(merchants).to have_key([:data])
        expect(merchants[:data]).to eq(expected)
      end
    end
  end

  describe "One Merchant" do
    it "returns one merchant given an id" do
      merchant_1 = create(:merchant)

      get "/api/v1/merchants/#{merchant_1.id}"

      expect(response).to be_success
  
      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant).to be_a(Hash)
      expect(merchant).to have_key(:data)
      expect(merchant.count).to eq(1)
      expect(merchant[:data]).to be_a(Hash)
      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id].to_i).to eq(merchant_1.id)
      expect(merchant[:data]).to have_key(:type)
      expect(merchant[:data][:type]).to eq('merchant')
      expect(merchant[:data]).to have_key(:attributes)
      expect(merchant[:data][:attributes]).to be_a(Hash)
      expect(merchant[:data][:attributes]).to have_key(:name)
    end
  end
end