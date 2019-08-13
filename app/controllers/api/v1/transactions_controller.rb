class Api::V1::TransactionsController < Api::V1::BaseController
  wrap_parameters false
  expose(:search)         { TransactionSearch.new(search_params) }
  expose (:transactions)  { search.results }
  expose (:transaction)   { transactions.find(params[:id]) }

  def index
    self.transactions = transactions.page(page_number).per(page_size)

    render json: transactions, each_serializer: TransactionSerializer
  end

  def show
    render json: transaction, serializer: TransactionSerializer
  end

  def create
    self.transaction = CreateTransactionInteractor.new(transaction_params).run
    render json: transaction, serializer: TransactionSerializer
  end

  private

  def search_params
    params[:search] || {}
  end

  def page_number
    params[:page] || 1
  end

  def page_size
    params[:page_size] || 25
  end

  def transaction_params
    params.permit(:user_id, :sum, :transaction_type)
  end
end