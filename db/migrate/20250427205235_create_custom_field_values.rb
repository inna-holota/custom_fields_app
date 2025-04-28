class CreateCustomFieldValues < ActiveRecord::Migration[6.0]
  def change
    create_table :custom_field_values do |t|
      t.references :user, null: false, foreign_key: true
      t.references :custom_field, null: false, foreign_key: true
      t.references :custom_field_option, foreign_key: true
      t.string :value
      
      t.timestamps

      t.index [:user_id, :custom_field_id, :custom_field_option_id], unique: true, name: 'custom_field_values_uniquness'
    end
  end
end
