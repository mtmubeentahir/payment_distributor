class CreateMerchants < ActiveRecord::Migration[7.0]
  def change
    create_table :merchants do |t|
      t.string :merchant_reference
      t.string :email
      t.datetime :live_on
      t.integer :frequency
      t.float :minimum_monthly_fee

      t.timestamps
    end
  end
end
