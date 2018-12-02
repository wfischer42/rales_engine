class Api::V1::Merchants::CustomersWithPendingInvoicesController < ApplicationController
  def index
    merchant_id = params["id"]
    unpaid_customers = Merchant.customers_with_pending_invoices(merchant_id)
    render json: CustomerSerializer.new(unpaid_customers)
  end
end
