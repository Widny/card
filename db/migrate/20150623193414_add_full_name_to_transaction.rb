class AddFullNameToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :full_name, :string
  end
end
