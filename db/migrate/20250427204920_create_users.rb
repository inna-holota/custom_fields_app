class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :first_name
      t.string :last_name
      t.timestamps
    end
    
    add_reference :users, :tenant, foreign_key: true, null: false
  end
end
