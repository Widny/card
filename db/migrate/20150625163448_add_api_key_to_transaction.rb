class AddApiKeyToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :api_key, :string
  end
end
