class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :deck
  has_many :comments

  after_commit { MessageRelayJob.perform_later(self) }
end
