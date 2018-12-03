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

  def self.merchant_revenue(id)
    Invoice.joins(:transactions)
           .joins(:invoice_items)
           .where(transactions: {result: :success})
           .where(merchant_id: id)
           .sum('unit_price * quantity')
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
                  bod, eod )
           .joins(:transactions)
           .merge(Transaction.success)
           .joins(:invoice_items)
           .sum('invoice_items.unit_price * invoice_items.quantity')
  end

  def self.merchant_revenue_on_date(merchant_id, date)
    bod = date + " 00:00:00"
    eod = date + " 23:59:59"
    Invoice.where('invoices.created_at > ? AND invoices.created_at < ?',
                  bod, eod )
           .where(merchant_id: merchant_id)
           .joins(:transactions)
           .merge(Transaction.success)
           .joins(:invoice_items)
           .sum('invoice_items.unit_price * invoice_items.quantity')
  end

  def self.merchant_favorite_customer(merchant_id)
    Customer.select("customers.*, COUNT(transactions) AS successful")
            .joins(invoices: :transactions)
            .merge(Transaction.success)
            .where(invoices: {merchant_id: merchant_id})
            .group(:id)
            .order("successful DESC")
            .limit(1)
            .first
  end

  def self.customers_with_pending_invoices(merchant_id)
    include_query = Customer.select('customers.*, invoices.id AS invoice_id')
                            .joins(:invoices)
                            .where(invoices: {merchant_id: merchant_id})
                            .to_sql

    exclude_query = Customer.select('customers.*, invoices.id AS invoice_id')
                            .joins(invoices: :transactions)
                            .where(invoices: {merchant_id: merchant_id})
                            .merge(Transaction.success)
                            .group('customers.id, invoices.id')
                            .having('invoices.id = MIN(invoices.id)')
                            .to_sql

    customer = Customer.find_by_sql(include_query + " EXCEPT " + exclude_query).uniq
  end
end
