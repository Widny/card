class AddCompanyToTransactions < ActiveRecord::Migration
  def change
    add_reference :transactions, :company, index: true, foreign_key: true
  end
end
