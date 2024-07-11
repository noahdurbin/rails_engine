require 'rails_helper'

describe 'merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful
    expect(response.status).to eq(200)

    merchants = JSON.parse(response.body, symbolize_names:true)

    merchants_objects = merchants[:data]
    expect(merchants_objects.count).to eq(3)

    merchants_objects.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'can get one merchant by its ID' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant_json = JSON.parse(response.body, symbolize_names:true)

    merchant = merchant_json[:data]

    expect(response).to be_successful

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to eq(id.to_s)

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)
  end

  it 'can send all items for a given merchant' do
    merchant = create(:merchant)
    create_list(:item, 5, merchant: merchant)
    create_list(:item, 2)

    get "/api/v1/merchants/#{merchant.id}/items"
    items = JSON.parse(response.body, symbolize_names:true)[:data]

    expect(response).to be_successful

    expect(items.count).to eq(5)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)
    end
  end

  describe '#us 10' do
    it 'searches for a specific name' do
      merchant = Merchant.create(name: "Turing")

      get "/api/v1/merchants/find?name=#{merchant.name}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      m = JSON.parse(response.body, symbolize_names:true)[:data]
      expect(m[:attributes][:name]).to eq("Turing")
    end

    it 'sad path for search for a merchant' do
      get "/api/v1/merchants/find?name=dadsa"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      res = JSON.parse(response.body, symbolize_names:true)[:errors]

      expect(res.first[:title]).to eq("Record Not Found")
    end

    it ' sad path error for invalid search params ' do
      get "/api/v1/merchants/find?name="
      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      res = JSON.parse(response.body, symbolize_names:true)[:errors]

      expect(res.first[:title]).to eq("Name Must Be Filled In")
    end
  end
end
