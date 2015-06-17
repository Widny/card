class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :card_number
      t.integer :exp_date
      t.integer :cvv
      t.integer :amount

      t.timestamps
    end
  end
end
