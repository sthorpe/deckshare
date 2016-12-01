class AddDataToDeck < ActiveRecord::Migration[5.0]
  def change
    add_column :decks, :data, :text
  end
end
