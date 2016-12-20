class CreateConversations < ActiveRecord::Migration[5.0]
  def change
    create_table :conversations do |t|
      t.integer :user_id
      t.string :fb_user
      t.text :body

      t.timestamps
    end
  end
end
