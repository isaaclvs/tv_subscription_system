class CreateInvoices < ActiveRecord::Migration[8.0]
  def change
    create_table :invoices do |t|
      t.references :subscription, null: false, foreign_key: true
      t.string :month_year, null: false
      t.decimal :total_amount, precision: 10, scale: 2, null: false
      t.date :due_date, null: false

      t.timestamps
    end

    add_index :invoices, [ :subscription_id, :month_year ], unique: true
  end
end
