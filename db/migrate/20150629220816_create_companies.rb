class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :firefly_api_key
      t.string :token_api_key

      t.timestamps null: false
    end
  end
end
