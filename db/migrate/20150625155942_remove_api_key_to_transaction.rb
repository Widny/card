class RemoveApiKeyToTransaction < ActiveRecord::Migration
  def change
    remove_column :transactions, :api_key, :json
  end
end
