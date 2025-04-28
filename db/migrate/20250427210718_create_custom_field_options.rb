class CreateCustomFieldOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :custom_field_options do |t|
      t.references :custom_field, null: false, foreign_key: true
      t.string :value, null: false
      t.timestamps
    end
  end
end
