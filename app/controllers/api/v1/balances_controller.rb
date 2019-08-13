class Api::V1::BalancesController < Api::V1::BaseController
  wrap_parameters false
  expose (:balances)  { Balance.all.includes(:user).page(page_number).per(page_size) }

  def index
    render json: balances, each_serializer: BalanceSerializer
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
end