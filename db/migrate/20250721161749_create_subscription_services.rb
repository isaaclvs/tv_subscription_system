class CreateSubscriptionServices < ActiveRecord::Migration[8.0]
  def change
    create_table :subscription_services do |t|
      t.references :subscription, null: false, foreign_key: true
      t.references :additional_service, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :subscription_services, [:subscription_id, :additional_service_id], unique: true, name: 'index_subscription_services_uniqueness'
  end
end
