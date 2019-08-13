class CreateTransactionInteractor
  attr_reader :params, :success, :transaction

  def initialize(params)
    @params = params
  end

  def run
    persist!

    if success?
      begin
        update_balance
      rescue ActiveRecord::LockWaitTimeout
        retry
      end
    end

    transaction
  end

  private

  def persist!
    @transaction = Transaction.new(params)
    @success = transaction.save!
  end

  def update_balance
    user    = transaction.user
    balance = user.balance

    if transaction.transaction_type == 'replenishment'
      balance.sum = balance.sum + transaction.sum
    else
      balance.sum = balance.sum - transaction.sum
    end

    Rails.logger.info balance.inspect

    balance.save!
  end

  def success?
    @success
  end
end