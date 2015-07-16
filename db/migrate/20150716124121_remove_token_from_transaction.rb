class RemoveTokenFromTransaction < ActiveRecord::Migration
  def change
    remove_column :transactions, :token, :string
  end
end
