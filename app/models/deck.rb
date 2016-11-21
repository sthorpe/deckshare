class Deck < ApplicationRecord
  has_attached_file :document,
  :storage => :s3,
  :default_url => "homer.png",
  :s3_region => ENV['AWS_REGION'],
  :s3_credentials => {
    :bucket => ENV['AWS_BUCKET'],
    :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
    :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
    :region => ENV['AWS_REGION']
  }
  validates_attachment :document, :content_type => { :content_type => %w(application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document) }, default_url: ->(attachment) { 'homer.png' }
  belongs_to :user
  has_many :shares
end
