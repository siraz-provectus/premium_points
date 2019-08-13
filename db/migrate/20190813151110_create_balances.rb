class CreateBalances < ActiveRecord::Migration[5.2]
  def change
    create_table :balances do |t|
      t.integer :user_id
      t.integer :sum, default: 0

      t.timestamps
    end
    add_index :balances, :user_id, unique: true
  end
end
