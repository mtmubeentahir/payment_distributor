class CreateDisbursments < ActiveRecord::Migration[7.0]
  def change
    create_table :disbursments do |t|
      t.float :commission
      t.float :merchant_payment
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
