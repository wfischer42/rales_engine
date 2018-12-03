require 'rails_helper'

RSpec.describe Api::V1::ItemsController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'responds with JSON' do
      items = build_stubbed_list(:item, 2)
      allow(Item).to receive(:all).and_return(items)

      get :index
      parsed = JSON.parse(response.body)["data"]

      expect(response.header['Content-Type']).to include('application/json')
      expect(parsed[0]["attributes"]).to include( {"id"   => items[0].id,
                                                   "name" => items[0].name})
      expect(parsed[1]["attributes"]).to include( {"id"   => items[1].id,
                                                   "name" => items[1].name})
    end
  end

  describe "GET #show" do
    let(:item) { create(:item) }

    it "returns http success" do
      get :show, params: { id: item.id }
      expect(response).to have_http_status(:success)
    end

    it 'should respond with JSON' do
      get :show, params: { id: item.id }
      parsed = JSON.parse(response.body)["data"]

      expect(response.header['Content-Type']).to include('application/json')
      expect(parsed["attributes"]).to include( {"id"   => item.id,
                                                "name" => item.name})
    end
  end

end
