require 'rails_helper'

RSpec.describe Api::V1::Merchants::RevenueController, type: :controller do
  describe 'GET index' do
    it 'should be successful' do
      get :index, params: { date: '2018-12-01' }

      expect(response).to have_http_status(:success)
    end

    it 'should respond with JSON' do
      allow(Merchant).to receive(:revenue_on_date)
                         .with('2018-12-01').and_return(1234567)

      get :index, params: { date: '2018-12-01' }
      parsed = JSON.parse(response.body)["data"]

      expect(response.header['Content-Type']).to include('application/json')
      expect(parsed["revenue"]).to eq(12345.67)
    end
  end

  describe 'GET show' do
    context 'with date parameter' do
      it 'should be successful' do
        get :show, params: { id: 1, date: '2018-12-01' }

        expect(response).to have_http_status(:success)
      end

      it 'should respond with JSON' do
        allow(Merchant).to receive(:merchant_revenue_on_date)
                           .with("1", '2018-12-01').and_return(1234567)

        get :show, params: { id: 1, date: '2018-12-01' }
        parsed = JSON.parse(response.body)["data"]

        expect(response.header['Content-Type']).to include('application/json')
        expect(parsed["revenue"]).to eq(12345.67)
      end
    end
    context 'without date parameter' do
      it 'should be successful' do
        get :show, params: { id: 1}

        expect(response).to have_http_status(:success)
      end

      it 'should respond with JSON' do
        allow(Merchant).to receive(:merchant_revenue).with("1")
                           .and_return(1234567)

        get :show, params: { id: 1 }
        parsed = JSON.parse(response.body)["data"]

        expect(response.header['Content-Type']).to include('application/json')
        expect(parsed["revenue"]).to eq(12345.67)
      end
    end
  end
end
