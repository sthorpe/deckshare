class AddClearbitToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :raw_clearbit_data, :text
  end
end
