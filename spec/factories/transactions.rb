FactoryBot.define do
  factory :transaction do
    user { nil }
    sum { 1 }
    transaction_type { 1 }
  end
end
