require 'rails_helper'

RSpec.describe "Item Api" do

  describe '#us4 get all items' do
    it 'gets all items' do
      create_list(:item, 5)
      get '/api/v1/items'

      items = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful

      items[:data].each do |item|
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)
     end
    end
  end

  describe '#us5 get one item' do
    it 'should only get one item' do
      item = create(:item)
      get "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      item = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)
    end
  end

  describe '#us6 create item' do
    it 'can create an item' do
      merchant1 = create(:merchant)

      item_params = {
        "name": "value1",
        "description": "value2",
        "unit_price": 100.99,
        "merchant_id": merchant1.id
      }

      post '/api/v1/items', params: item_params

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item).to have_key(:name)
      expect(item[:name]).to be_a(String)
      expect(item[:name]).to eq('value1')

      expect(item).to have_key(:description)
      expect(item[:description]).to be_a(String)
      expect(item[:description]).to eq('value2')

      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_a(Float)
      expect(item[:unit_price]).to eq(100.99)

      expect(item).to have_key(:merchant_id)
      expect(item[:merchant_id]).to eq(merchant1.id)
    end
  end

  describe '#us 7 edit an item' do
    it 'edits an item' do
      merchant = Merchant.create!(name: "Topps")
      i = Item.create!(name: "Ball", description: "Baseball", unit_price: 2.50, merchant_id: merchant.id)
      previous_name = i.name
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{i.id}", headers: headers, params: JSON.generate({name: "NAME1"})

      
      
      expect(response).to be_successful
      item = JSON.parse(response.body, symbolize_names: true)
      
      expect(item[:data][:attributes][:name]).to_not eq(previous_name)
      expect(item[:data][:attributes][:name]).to eq("NAME1")
    end
  end

  describe '#us 8 delete an item' do
    it 'deletes a specific item' do
      merchant = Merchant.create!(name: "Topps")
      i = Item.create!(name: "Ball", description: "Baseball", unit_price: 2.50, merchant_id: merchant.id)
     
      delete "/api/v1/items/#{i.id}"

      expect(response).to be_successful
      expect(response.status).to eq(204)
    end
  end
end
