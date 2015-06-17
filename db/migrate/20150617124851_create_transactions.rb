class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :card_number
      t.string :exp_date
      t.string :cvv
      t.decimal :amount

      t.timestamps
    end
  end
end
