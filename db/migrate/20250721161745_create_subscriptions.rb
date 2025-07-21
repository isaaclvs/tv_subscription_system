class CreateSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :subscriptions do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :plan, null: true, foreign_key: true
      t.references :package, null: true, foreign_key: true

      t.timestamps
    end
    
    # XOR constraint: must have either plan OR package, but not both
    add_check_constraint :subscriptions, 
      "(plan_id IS NOT NULL AND package_id IS NULL) OR (plan_id IS NULL AND package_id IS NOT NULL)",
      name: "subscriptions_plan_or_package_xor"
  end
end
