class Customer < ApplicationRecord
  has_many :invoices

  def self.favorite_merchant(customer_id)
    Merchant.select("merchants.*, COUNT(transactions) AS successful")
            .joins(invoices: :transactions)
            .merge(Transaction.success)
            .where(invoices: {customer_id: customer_id})
            .group(:id)
            .order("successful DESC")
            .limit(1)
            .first
  end
end
