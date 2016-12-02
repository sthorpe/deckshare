class UploadWorker
  include Sidekiq::Worker
  #sidekiq_options :queue => :default

  def perform(deck_id)
    puts "Generating pdf images for #{deck_id}"
    @deck = Deck.find(deck_id)
    @deck.build_slides
  end
end
