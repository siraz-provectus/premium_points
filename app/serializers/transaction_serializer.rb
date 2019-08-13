class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :sum, :transaction_type, :date, :user_name

  def date
    object.created_at
  end

  def user_name
    "#{object.user_first_name} #{object.user_last_name}"
  end
end