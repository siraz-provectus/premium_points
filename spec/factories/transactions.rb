FactoryBot.define do
  factory :transaction do
    user
    sum { 100 }
    transaction_type { 'replenishment' }
  end
end
