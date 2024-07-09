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
end