class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.integer :user_id
      t.integer :sum
      t.integer :transaction_type

      t.timestamps
    end

    add_index :transactions, :user_id
  end
end
