class AddAttachmentDocumentToDecks < ActiveRecord::Migration
  def self.up
    change_table :decks do |t|
      t.attachment :document
    end
  end

  def self.down
    remove_attachment :decks, :document
  end
end
