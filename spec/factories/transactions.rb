FactoryBot.define do
  factory :transaction do
    invoice { nil }
    credit_card_number { 1 }
    expiration_date { "2018-11-27" }
    result { 1 }
  end
end
