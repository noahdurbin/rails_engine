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

      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

      expect(response).to be_successful

      item = Item.last

      expect(item[:name]).to be_a(String)
      expect(item[:name]).to eq('value1')

      expect(item[:description]).to be_a(String)
      expect(item[:description]).to eq('value2')

      expect(item[:unit_price]).to be_a(Float)
      expect(item[:unit_price]).to eq(100.99)

      expect(item[:merchant_id]).to eq(merchant1.id)
    end

    it 'sad path' do
      merchant1 = create(:merchant)

      item_params = {
        "name": "value1",
        "description": "value2",
        "merchant_id": merchant1.id
      }

      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
      expect(response).to_not be_successful
      expect(response.status).to eq(400)
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

    it "sad path for edit" do
      merchant = Merchant.create!(name: "Topps")
      i = Item.create!(name: "Ball", description: "Baseball", unit_price: 2.50, merchant_id: merchant.id)
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{i.id}", headers: headers, params: JSON.generate({name: ""})

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      item = JSON.parse(response.body, symbolize_names: true)

     expect(item[:errors].first[:title]).to eq("Validation failed: Name can't be blank")
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

  describe '#us 9 ' do
    it 'returns the merchant of that item' do
      merchant1 = create(:merchant)
      item1 = create(:item, merchant: merchant1)

      get "/api/v1/items/#{item1.id}/merchant"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchant= JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end

    it 'sad path for the merchant of that item' do
      merchant1 = create(:merchant)

      get "/api/v1/items/12322/merchant"

      expect(response).to_not be_successful

      expect(response.status).to eq(404)

    end
  end

  describe '#us 11' do
    it 'should search for all of the items that match search criteria' do
      merchant = Merchant.create(name: "Topps")
      i = Item.create!(name: "Ball", description: "Baseball", unit_price: 2.50, merchant_id: merchant.id)

      create_list(:item, 5)
      get '/api/v1/items/find_all?name=ball'

      expect(response).to be_successful
      expect(response.status).to eq(200)

    end

    it 'sad path for invalid imput' do
      merchant = Merchant.create(name: "Topps")
      i = Item.create!(name: "Ball", description: "Baseball", unit_price: 2.50, merchant_id: merchant.id)

      get '/api/v1/items/find_all?name='

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end
  end

  describe '#search-extension' do
    it 'can find a single item by name' do
      item1 = create(:item, name: "Ring")
      item2 = create(:item, name: "Turing")

      get "/api/v1/items/find?name=ring"

      expect(response).to be_successful
      item = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(item[:attributes][:name]).to eq("Ring")
    end

    it 'can find a single item by minimum price' do
      item1 = create(:item, name: "Cheaper", unit_price: 10.00)
      item2 = create(:item, name: "Expensive", unit_price: 100.00)

      get "/api/v1/items/find?min_price=50"

      expect(response).to be_successful
      item = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(item[:attributes][:name]).to eq("Expensive")
    end

    it 'can find a single item by maximum price' do
      item1 = create(:item, name: "bike", unit_price: 10.00)
      item2 = create(:item, name: "motorbike", unit_price: 100.00)

      get "/api/v1/items/find?max_price=50"

      expect(response).to be_successful
      item = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(item[:attributes][:name]).to eq("bike")
    end

    it 'returns an error when searching by both name and price' do
      get "/api/v1/items/find?name=ring&min_price=50"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end
  end

  describe '#search_all_extension' do
    it 'can find all items matching a name search' do
      item1 = create(:item, name: "Ring")
      item2 = create(:item, name: "Turing")
      item3 = create(:item, name: "Other")

      get "/api/v1/items/find_all?name=ring"

      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(items.length).to eq(2)
    end

    it 'can find all items within a price range' do
      item1 = create(:item, name: "iphone", unit_price: 10.00)
      item2 = create(:item, name: "ipad", unit_price: 50.00)
      item3 = create(:item, name: "mac", unit_price: 100.00)

      get "/api/v1/items/find_all?min_price=20&max_price=80"

      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(items.length).to eq(1)
      expect(items.first[:attributes][:name]).to eq("ipad")
    end

    it 'returns an empty array when no items match the search' do
      get "/api/v1/items/find_all?name=NOMATCH"

      expect(response).to be_successful
      expect(response.status).to eq(200)
      items = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(items).to eq([])
    end

    it 'raises an error if you try to search with name and price' do
      item1 = create(:item, name: "iphone", unit_price: 10.00)

      get "/api/v1/items/find_all?name=iphone&max_price=80"

      expect(response).to_not be_successful
      expect(response.status).to eq 400
    end

    it 'raises an error if max price is lower than or equal to min price' do
      item1 = create(:item, name: "iphone", unit_price: 10.00)

      get "/api/v1/items/find_all?min_price=100&max_price=80"

      expect(response).to_not be_successful
      expect(response.status).to eq 400
    end

    it 'raises an error if a search price is negative' do
      item1 = create(:item, name: "iphone", unit_price: 10.00)

      get "/api/v1/items/find_all?min_price=-100"

      expect(response).to_not be_successful
      expect(response.status).to eq 400
    end
  end
end
