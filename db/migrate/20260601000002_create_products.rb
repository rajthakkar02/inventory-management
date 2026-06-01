class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :category, null: false
      t.string :brand
      t.string :model_number
      t.string :imei
      t.string :color
      t.string :storage
      t.string :accessory_type
      t.decimal :purchase_price, precision: 10, scale: 2
      t.decimal :selling_price, precision: 10, scale: 2, null: false
      t.integer :quantity, null: false, default: 0
      t.text :description
      t.boolean :active, null: false, default: true
      t.timestamps
    end

    add_index :products, :imei, unique: true, where: "imei IS NOT NULL"
    add_index :products, [:name, :brand, :category]
    add_index :products, :category
    add_index :products, :brand
    add_index :products, :quantity
  end
end
