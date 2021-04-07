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

        expect(merchants).to be_a(Hash)
        expect(merchants).to have_key(:data)
        expect(merchants[:data]).to be_an(Array)
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

  describe "merchants items" do
    describe "happy path" do
      it "returns all the items for a merchant given an id" do
        merchant_1 = create(:merchant)
        create_list(:item, 10, merchant: merchant_1)

        get "/api/v1/merchants/#{merchant_1.id}/items"
        expect(response).to be_success

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items).to be_a(Hash)
        expect(items).to have_key(:data)
        expect(items[:data]).to be_an(Array)
        expect(items[:data].count).to eq(10)
        expect(items[:data][0]).to have_key(:id)
        expect(items[:data][0]).to have_key(:attributes)
        expect(items[:data][0][:attributes]).to have_key(:name)
        expect(items[:data][0][:attributes]).to have_key(:description)
        expect(items[:data][0][:attributes]).to have_key(:unit_price)
        expect(items[:data][0][:attributes]).to have_key(:merchant_id)
      end
    end

    describe "sad path" do
      it 'returns an empty array if there are no items for the given merchant' do
        merchant_1 = create(:merchant)

        get "/api/v1/merchants/#{merchant_1.id}/items"
        expect(response).to be_success
        
        items = JSON.parse(response.body, symbolize_names: true)
        expected = []
        expect(items).to be_a(Hash)
        expect(items).to have_key(:data)
        expect(items[:data]).to eq(expected)
      end
    end
  end

  describe "find merchant" do
    describe "happy path" do
      it "finds a single merchant from a search query" do
        create(:merchant, name: "Ring World")
  
        get "/api/v1/merchants/find?name=Ring"
        expect(response).to be_successful
  
        merchant = JSON.parse(response.body, symbolize_names: true)
  
        expect(merchant).to be_a(Hash)
        expect(merchant).to have_key(:data)
        expect(merchant[:data]).to be_a(Hash)
      end

      it "finds a single merchant from a search query regardless of capitalization" do
        create(:merchant, name: "Ring World")
  
        get "/api/v1/merchants/find?name=ring"
        expect(response).to be_successful
  
        merchant = JSON.parse(response.body, symbolize_names: true)
  
        expect(merchant).to be_a(Hash)
        expect(merchant).to have_key(:data)
        expect(merchant[:data]).to be_a(Hash)
      end

      it "finds a single merchant from a search query fragment" do
        create(:merchant, name: "Ring World")
  
        get "/api/v1/merchants/find?name=ri"
        expect(response).to be_successful
  
        merchant = JSON.parse(response.body, symbolize_names: true)
  
        expect(merchant).to be_a(Hash)
        expect(merchant).to have_key(:data)
        expect(merchant[:data]).to be_a(Hash)
      end

      it "finds the first alphabetical merchant regardless of creation time" do
        turing = create(:merchant, name: "Turing")
        ring_world = create(:merchant, name: "Ring World")

        get "/api/v1/merchants/find?name=ring"
        expect(response).to be_successful
  
        merchant = JSON.parse(response.body, symbolize_names: true)
  
        expect(merchant).to be_a(Hash)
        expect(merchant).to have_key(:data)
        expect(merchant[:data]).to be_a(Hash)
        expect(merchant[:data]).to have_key(:id)
        expect(merchant[:data][:id].to_i).to eq(ring_world.id)
        expect(merchant[:data]).to have_key(:attributes)
        expect(merchant[:data][:attributes]).to have_key(:name)
        expect(merchant[:data][:attributes][:name]).to eq(ring_world.name)
      end
    end

    describe "sad path" do
      it "returns and empty hash if nothing is found" do
        create(:merchant, name: "Some Name")

        get "/api/v1/merchants/find?name=different"
        expect(response).to be_successful

        merchant = JSON.parse(response.body, symbolize_names: true)

        expected = {}
        expect(merchant).to be_a(Hash)
        expect(merchant).to have_key(:data)
        expect(merchant[:data]).to eq(expected)
      end
    end
  end
end