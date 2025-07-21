class CreatePackages < ActiveRecord::Migration[8.0]
  def change
    create_table :packages do |t|
      t.string :name
      t.references :plan, null: false, foreign_key: true
      t.decimal :price, precision: 10, scale: 2

      t.timestamps
    end
  end
end
