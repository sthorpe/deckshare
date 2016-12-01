class AddPdfUrlToDecks < ActiveRecord::Migration[5.0]
  def change
    add_column :decks, :pdf_url, :string
  end
end
