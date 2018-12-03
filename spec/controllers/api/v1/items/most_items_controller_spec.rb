require 'rails_helper'

RSpec.describe Api::V1::Items::MostItemsController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index, params: { quantity: 1 }
      expect(response).to have_http_status(:success)
    end
  end

  it 'responds with JSON' do
    items = build_stubbed_list(:item, 2)
    allow(Item).to receive(:most_sold).with("2")
                                     .and_return(items)

    get :index, params: { quantity: 2 }
    parsed = JSON.parse(response.body)["data"]
    expected = { "id"          => items[0].id,
                 "name"        => items[0].name,
                 "description" => items[0].description,
                 "merchant_id" => items[0].merchant_id }

    expect(response.header['Content-Type']).to include('application/json')
    expect(parsed[0]["attributes"]).to include(expected)
    expect(parsed.length).to eq(2)
  end

end
