require 'rails_helper'

RSpec.describe Merchant, type: :model do
  it { is_expected.to have_many(:invoices) }
  it { is_expected.to have_many(:items) }
  it { is_expected.to have_many(:invoice_items).through(:invoices) }

  # GET /api/v1/merchants/:id/revenue returns the total revenue for that merchant across successful transactions
  describe "Instance Methods" do
    describe ".revenue" do
      it "returns a merchant's total revenue" do
        merchant = create(:merchant)
        inv_item_1 = create(:invoice_item, merchant:     merchant,
                                           unit_price:   1111,
                                           quantity:     3,
                                           trans_result: :success)
        inv_item_2 = create(:invoice_item, merchant:     merchant,
                                           unit_price:   2222,
                                           quantity:     1,
                                           trans_result: :success)

        expect(merchant.revenue).to eq(5555)
      end

      it "doesn't include pending invoices in total revenue" do
        merchant = create(:merchant)
        inv_item_1 = create(:invoice_item, merchant: merchant,
                                           trans_result: :failed)
        inv_item_2 = create(:invoice_item, merchant: merchant,
                                           trans_result: nil)

        expect(merchant.revenue).to eq(0)
      end

      it "doesn't include other merchant's invoices in revenue" do
        merchant_1 = create(:merchant)
        merchant_2 = create(:merchant)
        inv_item = create(:invoice_item, merchant: merchant_2,
                                         trans_result: :success)

        expect(merchant_1.revenue).to eq(0)
      end
    end

    describe ".items_sold" do
      it "returns a merchant's total number of items sold (in units)" do
        merchant = create(:merchant)
        inv_item_1 = create(:invoice_item, merchant: merchant,
                                           quantity: 17)
        inv_item_2 = create(:invoice_item, merchant: merchant,
                                           quantity: 33)
        create(:transaction, result: :success, invoice: inv_item_1.invoice)
        create(:transaction, result: :success, invoice: inv_item_2.invoice)

        expect(merchant.items_sold).to eq(50)
      end

      it "doesn't include pending invoices in items sold" do
        merchant = create(:merchant)
        inv_item_1 = create(:invoice_item, merchant: merchant)
        inv_item_2 = create(:invoice_item, merchant: merchant)
        create(:transaction, result: :failed, invoice: inv_item_1.invoice)
        # First invoice has a pending transaction. Second has no transaction.

        expect(merchant.items_sold).to eq(0)
      end

      it "doesn't include other merchant's invoices in revenue" do
        merchant_1 = create(:merchant)
        merchant_2 = create(:merchant)
        inv_item = create(:invoice_item, merchant: merchant_2)
        create(:transaction, result: :success, invoice: inv_item.invoice)

        expect(merchant_1.items_sold).to eq(0)
      end
    end
  end

  describe "Class Methods" do
    describe "#with_most_revenue(quantity)" do
      it "returns the x merchants with the most revenue" do
        merchants = create_list(:merchant, 2)
        inv_item_1 = create(:invoice_item, unit_price: 10, quantity: 2,
                                           merchant: merchants[0],
                                           trans_result: :success)
        inv_item_2 = create(:invoice_item, unit_price: 3, quantity: 7,
                                           merchant:   merchants[1],
                                           trans_result: :success)

        top = Merchant.with_most_revenue(1)
        top_2 = Merchant.with_most_revenue(2)

        expect(top).to eq([merchants[1]])
        expect(top_2).to eq([merchants[1], merchants[0]])
      end

      it "doesn't include pending invoices in calculations" do
        merchants = create_list(:merchant, 2)
        inv_item_1 = create(:invoice_item, unit_price: 10, quantity: 2,
                                           merchant: merchants[0],
                                           trans_result: :success)
        inv_item_2 = create(:invoice_item, unit_price: 3, quantity: 7,
                                           merchant:   merchants[1],
                                           trans_result: :failed)
        inv_item_3 = create(:invoice_item, unit_price: 100, quantity: 1000,
                                           merchant:   merchants[1])

        top = Merchant.with_most_revenue(1)

        expect(top).to eq([merchants[0]])
      end

      it "returns number of results requested, up to all entries" do
        create_list(:invoice_item, 5, trans_result: :success)

        top_4 = Merchant.with_most_revenue(4)
        top_6 = Merchant.with_most_revenue(6)

        expect(top_4.length).to eq(4)
        expect(top_6.length).to eq(5)
      end
    end

    describe "#with_most_items_sold(quantity)" do
      it "returns the x merchants with the most items sold (in units)" do
        merchants = create_list(:merchant, 2)
        inv_item_1 = create(:invoice_item, quantity: 2,
                                           merchant: merchants[0],
                                           trans_result: :success)
        inv_item_2 = create(:invoice_item, quantity: 7,
                                           merchant:   merchants[1],
                                           trans_result: :success)

        top = Merchant.with_most_items_sold(1)
        top_2 = Merchant.with_most_items_sold(2)

        expect(top).to eq([merchants[1]])
        expect(top_2).to eq([merchants[1], merchants[0]])
      end

      it "doesn't include pending invoices in calculations" do
        merchants = create_list(:merchant, 2)
        inv_item_1 = create(:invoice_item, quantity:     2,
                                           merchant:     merchants[0],
                                           trans_result: :success)
        inv_item_2 = create(:invoice_item, quantity:     7,
                                           merchant:     merchants[1],
                                           trans_result: :failed)
        inv_item_3 = create(:invoice_item, quantity:     1000,
                                           merchant:     merchants[1],
                                           trans_result: nil)

        top = Merchant.with_most_items_sold(1)

        expect(top).to eq([merchants[0]])
      end

      it "returns number of results requested, up to all entries" do
        create_list(:invoice_item, 5, trans_result: :success)

        top_4 = Merchant.with_most_items_sold(4)
        top_6 = Merchant.with_most_items_sold(6)

        expect(top_4.length).to eq(4)
        expect(top_6.length).to eq(5)
      end
    end

    describe "#revenue_on_date(date)" do
      it "returns the total revene by all merchants on x date" do
        create(:invoice_item, unit_price: 12, quantity: 7,
                              trans_result: :success,
                              created_at: '2012-02-17 08:13:09')
        create(:invoice_item, unit_price: 9, quantity: 14,
                              trans_result: :success,
                              created_at: '2012-02-17 21:54:31')

        revenue = Merchant.revenue_on_date('2012-02-17')

        expect(revenue).to eq((12 * 7) + (9 * 14))
      end

      it "doesn't include pending invoices in calculations" do
        create(:invoice_item, unit_price: 12, quantity: 7,
                              trans_result: :success,
                              created_at: '2012-02-17 12:00:00')
        create(:invoice_item, unit_price: 9, quantity: 13,
                              trans_result: :failed,
                              created_at: '2012-02-17 12:00:00')
        create(:invoice_item, unit_price: 142, quantity: 8,
                              trans_result: nil,
                              created_at: '2012-02-17 12:00:00')

        revenue = Merchant.revenue_on_date('2012-02-17')

        expect(revenue).to eq(12 * 7)
      end

      it "doesn't include invoices from different dates" do
        date_1 = '2012-02-17'
        date_2 = '2012-02-18'
        create(:invoice_item, unit_price: 12, quantity: 7,
                              trans_result: :success,
                              created_at: date_1 + ' 12:00:00')
        create(:invoice_item, unit_price: 9, quantity: 13,
                              trans_result: :success,
                              created_at: date_2 + ' 12:00:00')

        revenue = Merchant.revenue_on_date(date_2)

        expect(revenue).to eq(9 * 13)
      end
    end

    describe "#merchant_revenue_on_date(merchant_id, date)" do
      # GET /api/v1/merchants/:id/revenue?date=x returns the total revenue for that merchant for a specific invoice date x
      it "returns the total revene by selected merchants on x date" do
        merchant = create(:merchant)
        create(:invoice_item, unit_price: 12, quantity: 7,
                              trans_result: :success,
                              created_at: '2012-02-17 08:13:09',
                              merchant: merchant)

        revenue = Merchant.merchant_revenue_on_date(merchant.id, '2012-02-17')

        expect(revenue).to eq((12 * 7))
      end

      it "doesn't include pending invoices in calculations" do
        merchant = create(:merchant)
        create(:invoice_item, unit_price: 12, quantity: 7,
                              trans_result: :success,
                              created_at: '2012-02-17 12:00:00',
                              merchant: merchant)
        create(:invoice_item, unit_price: 9, quantity: 13,
                              trans_result: :failed,
                              created_at: '2012-02-17 12:00:00',
                              merchant: merchant)
        create(:invoice_item, unit_price: 142, quantity: 8,
                              trans_result: nil,
                              created_at: '2012-02-17 12:00:00',
                              merchant: merchant)

        revenue = Merchant.merchant_revenue_on_date(merchant.id, '2012-02-17')

        expect(revenue).to eq(12 * 7)
      end

      it "doesn't include invoices from different dates" do
        date_1 = '2012-02-17'
        date_2 = '2012-02-18'
        merchant = create(:merchant)
        create(:invoice_item, unit_price: 12, quantity: 7,
                              trans_result: :success,
                              created_at: date_1 + ' 12:00:00',
                              merchant: merchant)
        create(:invoice_item, unit_price: 9, quantity: 13,
                              trans_result: :success,
                              created_at: date_2 + ' 12:00:00',
                              merchant: merchant)

        revenue = Merchant.merchant_revenue_on_date(merchant.id, date_2)

        expect(revenue).to eq(9 * 13)
      end

      it "doesn't include invoices from different merchants" do
        date = '2012-02-17'
        datetime = date + ' 12:00:00'
        merchants = create_list(:merchant, 2)
        create(:invoice_item, unit_price: 12, quantity: 7,
                              trans_result: :success,
                              created_at: datetime,
                              merchant: merchants[0])
        create(:invoice_item, unit_price: 9, quantity: 13,
                              trans_result: :success,
                              created_at: datetime,
                              merchant: merchants[1])

        revenue = Merchant.merchant_revenue_on_date(merchants[0].id, date)

        expect(revenue).to eq(12 * 7)
      end
    end

    describe "#favorite_customer" do
      it "returns customer with most successful transactions for merchant" do
        merchant = create(:merchant)
        customers = create_list(:customer, 2)
        create(:invoice_item, trans_result: :success,
                              merchant: merchant,
                              customer: customers[0])
        create(:invoice_item, trans_result: :failed,
                              merchant: merchant,
                              customer: customers[0])
        create_list(:invoice_item, 2, trans_result: :success,
                                      merchant: merchant,
                                      customer: customers[1])
        favorite = Merchant.merchant_favorite_customer(merchant.id)

        expect(favorite).to eq(customers[1])
      end
    end
    # BOSS MODE: GET /api/v1/merchants/:id/customers_with_pending_invoices returns a collection of customers which have pending (unpaid) invoices. A pending invoice has no transactions with a result of success. This means all transactions are failed. Postgres has an EXCEPT operator that might be useful. ActiveRecord also has a find_by_sql that might help.
  end
end
