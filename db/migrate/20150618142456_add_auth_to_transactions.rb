class AddAuthToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :auth_code, :string
  end
end
