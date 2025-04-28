class CreateCustomFields < ActiveRecord::Migration[6.0]
  def change
    create_table :custom_fields do |t|
      t.references :tenant, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :field_type, null: false
      t.timestamps

      t.index [:tenant_id, :name], unique: true
    end
  end
end
