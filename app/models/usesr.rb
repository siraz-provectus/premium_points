class Usesr < ApplicationRecord
  has_one :balance
  has_many :transactions

  after_create :create_balance_callback

  private

  def create_balance_callback
    self.create_balance
  end
end
