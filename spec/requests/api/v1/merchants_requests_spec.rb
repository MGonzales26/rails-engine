require 'rails_helper'

RSpec.describe "Merchants API" do
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
    expect(merchants[:data]).to be_an(Array)
    expect(merchants[:data][0][:id].to_i).to eq(merchant_6.id)
    expect(merchants[:data][4][:id].to_i).to eq(merchant_10.id)
  end
end