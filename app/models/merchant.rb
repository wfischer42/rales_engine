class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items

  has_many :invoice_items, through: :invoices

  def revenue
    self.invoices
        .joins(:transactions)
        .joins(:invoice_items)
        .where(transactions: {result: :success})
        .sum('unit_price * quantity')
  end

  def items_sold
    self.invoices
        .joins(:transactions)
        .joins(:invoice_items)
        .where(transactions: {result: :success})
        .sum('quantity')
  end

  def self.with_most_revenue(quantity)
    Merchant.unscoped
            .select('merchants.*, sum(unit_price * quantity) AS revenue')
            .joins(invoices: :transactions)
            .joins(invoices: :invoice_items)
            .where(transactions: {result: 1})
            .group(:id)
            .order('revenue DESC')
            .order('merchants.id ASC')
            .limit(quantity)
  end

  def self.with_most_items_sold(quantity)
    Merchant.unscoped
            .select('merchants.*, sum(quantity) AS items_sold')
            .joins(invoices: :transactions)
            .joins(invoices: :invoice_items)
            .where(transactions: {result: 1})
            .group(:id)
            .order('items_sold DESC')
            .order('merchants.id ASC')
            .limit(quantity)
  end

  def self.revenue_on_date(date)
    bod = date + " 00:00:00"
    eod = date + " 23:59:59"
    Invoice.where('invoices.created_at > ? AND invoices.created_at < ?',
                  bod,
                  eod )
           .joins(:transactions)
           .merge(Transaction.success)
           .joins(:invoice_items)
           .sum('invoice_items.unit_price * invoice_items.quantity')
  end
end
