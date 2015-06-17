class AddNumberToCard < ActiveRecord::Migration
  def change
    remove_column :transactions, :card_number, :integer
    add_column :transactions, :card_number, :bigint
  end
end
