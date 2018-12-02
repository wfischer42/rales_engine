class Api::V1::Merchants::FavoriteCustomerController < ApplicationController
  def show
    id = params["id"]
    favorite = Merchant.merchant_favorite_customer(id)
    render json: CustomerSerializer.new(favorite)
  end
end
