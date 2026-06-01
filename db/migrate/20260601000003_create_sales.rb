class CreateSales < ActiveRecord::Migration[8.1]
  def change
    create_table :sales do |t|
      t.references :product, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :customer_name
      t.string :customer_phone
      t.integer :quantity, null: false, default: 1
      t.decimal :unit_price, precision: 10, scale: 2, null: false
      t.decimal :discount, precision: 10, scale: 2, default: 0
      t.decimal :total_amount, precision: 10, scale: 2, null: false
      t.string :payment_method, null: false, default: "cash"
      t.text :notes
      t.datetime :sold_at, null: false
      t.timestamps
    end

    add_index :sales, :sold_at
    add_index :sales, :payment_method
    add_index :sales, :customer_phone
  end
end
