class AddCustZipToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :cust_zip, :string
  end
end
