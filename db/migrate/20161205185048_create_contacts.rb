class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.string :email
      t.integer :user_id
      t.string :name

      t.timestamps
    end
  end
end
