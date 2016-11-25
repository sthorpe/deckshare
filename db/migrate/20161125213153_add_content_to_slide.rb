class AddContentToSlide < ActiveRecord::Migration[5.0]
  def change
    add_column :slides, :content, :text
  end
end
