class TransactionSearch < Searchlight::Search
  def base_query
    Transaction.all.includes(:user)
  end

  def search_user_id
    query.where(user_id: user_id)
  end
end