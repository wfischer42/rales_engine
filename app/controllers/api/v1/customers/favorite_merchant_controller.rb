class Api::V1::Customers::FavoriteMerchantController < ApplicationController
  def show
    id = params["id"]
    favorite = Customer.favorite_merchant(id)
    render json: MerchantSerializer.new(favorite)
  end
end
