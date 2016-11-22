class CreateSlides < ActiveRecord::Migration[5.0]
  def change
    create_table :slides do |t|
      t.references :deck, index: true, foreign_key: true
      t.text :text
      t.timestamps
    end
  end
end
