FactoryBot.define do
  factory :balance do
    user
    sum { 1 }
  end
end
