class Balance < ApplicationRecord
  belongs_to :user
  validates :sum, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :user_id, uniqueness: true
  delegate :first_name, :last_name, to: :user, prefix: :user
end
