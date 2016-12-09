class SaveGoogleContactsWorker
  include Sidekiq::Worker
  #sidekiq_options :queue => :default

  def perform(user_id)
    user = User.find(user_id)
    user.save_google_contacts(user.oauth_token, max_results: '20000')
  end
end
