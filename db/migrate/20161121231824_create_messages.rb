class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :user, index: true, foreign_key: true

      t.string :title
      t.text :content
      t.integer :deck_id
      t.timestamps
    end
  end
end
