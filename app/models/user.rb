class User < ApplicationRecord
  has_one :balance, dependent: :destroy
  has_many :transactions, dependent: :destroy

  after_create :create_balance_callback

  private

  def create_balance_callback
    self.create_balance
  end
end
