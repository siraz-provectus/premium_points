class BalanceSerializer < ActiveModel::Serializer
  attributes :id, :sum, :user_name

  def user_name
    "#{object.user_first_name} #{object.user_last_name}"
  end
end