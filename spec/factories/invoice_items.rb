FactoryBot.define do
  factory :invoice_item do
    transient do
      merchant { create(:merchant) }
      customer { create(:customer) }
      trans_result { nil }
    end

    item { create(:item, merchant: merchant) }
    invoice { create(:invoice, merchant: merchant,
                               customer: customer,
                               created_at: created_at) }

    quantity { 1 }
    unit_price { 1 }

    after(:create) do |invoice_item, evaluator|
      result = evaluator.trans_result
      if result
        create(:transaction, invoice: invoice_item.invoice, result: result)
      end
    end
  end
end
