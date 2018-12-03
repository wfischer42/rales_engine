require 'rails_helper'

RSpec.describe Api::V1::Items::BestDayController, type: :controller do

  describe "GET #show" do
    it "returns http success" do
      get :show, params: { id: 1 }
      expect(response).to have_http_status(:success)
    end

    it 'responds with JSON' do
      allow(Item).to receive(:best_day).with("1")
                                       .and_return('2011-01-11T00:00:00.000Z')

      get :show, params: { id: 1 }
      parsed = JSON.parse(response.body)["data"]
      expected = { "best_day" => '2011-01-11T00:00:00.000Z'}

      expect(response.header['Content-Type']).to include('application/json')
      expect(parsed["attributes"]).to include(expected)
    end
  end

end
