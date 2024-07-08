FactoryBot.define do 
  factory :transaction do 
    credit_card_number { Faker::Finance.credit_card(:mastercard) }
    credit_card_expiration_date { Faker::Date.forward(days: 100) }
    result { ['success', 'failed'].sample }
  end
end