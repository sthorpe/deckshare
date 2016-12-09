class SaveGoogleContactsWorker
  include Sidekiq::Worker
  #sidekiq_options :queue => :default

  def perform(user_id)
    user = User.where(id: user_id).take
    user.save_google_contacts(user.oauth_token, max_results: '20000', user_id: user.id, email: user.email)
  end
end
