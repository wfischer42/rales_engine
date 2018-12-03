class Api::V1::Merchants::RevenueController < ApplicationController
  def index
    date = params["date"]
    render json: serialize_currency("total_revenue", Merchant.revenue_on_date(date))
  end

  def show
    id = params["id"]
    if date = params["date"]
      render json: serialize_currency("revenue", Merchant.merchant_revenue_on_date(id, date))
    else
      render json: serialize_currency("revenue", Merchant.merchant_revenue(id))
    end
  end
end
