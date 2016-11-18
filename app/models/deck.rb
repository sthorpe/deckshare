class Deck < ApplicationRecord
  has_attached_file :document
  validates_attachment :document, :content_type => { :content_type => %w(application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document) }, default_url: ->(attachment) { 'homer.png' }
  belongs_to :user
  has_many :shares
end
