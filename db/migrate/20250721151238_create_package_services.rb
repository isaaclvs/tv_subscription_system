class CreatePackageServices < ActiveRecord::Migration[8.0]
  def change
    create_table :package_services do |t|
      t.references :package, null: false, foreign_key: true
      t.references :additional_service, null: false, foreign_key: true

      t.timestamps
    end

    add_index :package_services, [ :package_id, :additional_service_id ], unique: true, name: 'index_package_services_uniqueness'
  end
end
