require 'rails_helper'

RSpec.describe Customer, type: :model do
  it { is_expected.to have_many(:invoices)}

  # GET /api/v1/customers/:id/favorite_merchant returns a merchant where the customer has conducted the most successful transactions
  describe "Class Methods" do
    describe "favorite_merchant(customer_id)" do
      it "returns customer with most successful transactions for merchant" do
        merchants = create_list(:merchant, 2)
        customer = create(:customer)
        create(:invoice_item, trans_result: :success,
                              merchant: merchants[0],
                              customer: customer)
        create(:invoice_item, trans_result: :failed,
                              merchant: merchants[0],
                              customer: customer)
        create_list(:invoice_item, 2, trans_result: :success,
                                      merchant: merchants[1],
                                      customer: customer)
        favorite = Customer.favorite_merchant(customer.id)

        expect(favorite).to eq(merchants[1])
      end
    end
  end
end
