class Slide < ApplicationRecord
  default_scope { order(created_at: :asc) }
  has_attached_file :image,
  storage: :s3,
  styles: { medium: "300x300>", thumb: "100x100>" },
  default_url: "homer.png",
  s3_region: ENV['AWS_REGION'],
  s3_credentials: {
    bucket: ENV['AWS_BUCKET'],
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region: ENV['AWS_REGION']
  }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  belongs_to :deck

  QUALITY = 100
  DENSITY = '80x80'

  serialize(:content, JSON)



end
