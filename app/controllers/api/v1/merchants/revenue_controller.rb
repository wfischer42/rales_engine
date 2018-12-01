class Api::V1::Merchants::RevenueController < ApplicationController
  def show
    date = params["date"]
    render json: serialize_currency("revenue", Merchant.revenue_on_date(date))
  end
end
