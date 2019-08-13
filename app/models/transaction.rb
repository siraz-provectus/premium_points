class Transaction < ApplicationRecord
  belongs_to :user
  validates :sum, numericality: {only_integer: true, greater_than_or_equal_to: 1}
  validates :transaction_type,  presence: true

  enum transaction_type: {
    replenishment: 0,
    withdrawal: 1
  }

  delegate :first_name, :last_name, to: :user, prefix: :user
end
