class AddClearBitToContacts < ActiveRecord::Migration[5.0]
  def change
    add_column :contacts, :raw_clearbit_data, :text
  end
end
