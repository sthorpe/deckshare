class CreateShares < ActiveRecord::Migration[5.0]
  def change
    create_table :shares do |t|
      t.string :url
      t.string :visits
      t.integer :deck_id
      t.string :email

      t.timestamps
    end
  end
end
