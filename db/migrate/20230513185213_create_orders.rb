class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :merchant_reference
      t.float :amount

      t.timestamps
    end
  end
end
