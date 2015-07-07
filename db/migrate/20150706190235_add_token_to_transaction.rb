class AddTokenToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :token, :string
  end
end
