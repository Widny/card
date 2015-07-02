class RemoveApiKeyFromTransaction < ActiveRecord::Migration
  def change
    remove_column :transactions, :api_key, :string
  end
end
