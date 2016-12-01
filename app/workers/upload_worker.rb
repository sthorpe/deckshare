class UploadWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :default

  def perform(deck_id)
    puts "#{deck_id} <---- Deck id"
    @deck = Deck.find(deck_id)
    @deck.build_slides
  end
end
