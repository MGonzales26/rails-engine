require 'rails_helper'

RSpec.describe "Items API" do
  it "gets all items limited to 20 unless optional query params passed" do
    merchant_1 = create(:merchant)
    create_list(:item, 50, merchant: merchant_1)

    get '/api/v1/items'

    expect(response).to be_success

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(20)

    get '/api/v1/items?per_page=45'

    expect(response).to be_success

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(45)
  end

  it "gets all items limited to 20 unless optional query params passed including page numbers" do
    merchant_1 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_1)
    item_3 = create(:item, merchant: merchant_1)
    item_4 = create(:item, merchant: merchant_1)
    item_5 = create(:item, merchant: merchant_1)
    item_6 = create(:item, merchant: merchant_1)
    item_7 = create(:item, merchant: merchant_1)
    item_8 = create(:item, merchant: merchant_1)
    item_9 = create(:item, merchant: merchant_1)
    item_10 = create(:item, merchant: merchant_1)

    get '/api/v1/items?per_page=8'

    expect(response).to be_success

    items = JSON.parse(response.body, symbolize_names: true)
    expect(items[:data].count).to eq(8)

    get '/api/v1/items?per_page=5&page=2'

    expect(response).to be_success

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items).to be_a(Hash)
    expect(items[:data]).to be_an(Array)
    expect(items[:data][0][:id].to_i).to eq(item_6.id)
    expect(items[:data][4][:id].to_i).to eq(item_10.id)
  end
end