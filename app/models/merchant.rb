class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items

  has_many :invoice_items, through: :invoices

  def revenue
    # I think this is 2 queries. Check, then use self.id to scope the invoices
    # directly
    self.invoices
        .joins(:transactions)
        .joins(:invoice_items)
        .where(transactions: {result: :success})
        .sum('unit_price * quantity')
  end

  def self.with_most_revenue(quantity)
    Merchant.select('merchants.*, sum(unit_price * quantity) AS revenue').joins(invoices: :transactions).joins(invoices: :invoice_items).where(transactions: {result: 1}).group(:id).order('revenue DESC').limit(quantity)
  end
end
