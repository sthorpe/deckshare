
class Deck < ApplicationRecord
  default_scope { order(created_at: :asc) }
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
  mount_uploader :pdf, PdfUploader
  belongs_to :user
  has_many :shares
  has_many :messages
  has_many :slides, :dependent => :destroy

  serialize(:data, JSON)

  def build_slides
    if valid?
      Paperclip.run('convert', "-quality #{Slide::QUALITY} -density #{Slide::DENSITY} #{pdf_local_path} #{pdf_local_path}%d.png")
      images = Dir.glob("#{pdf_local_path}*.png").sort_by do |line|
        line.match(/(\d+)\.png$/)[1].to_i
      end

      images.each do |slide_image|
        slides.build(:image => File.open(slide_image))
      end
      FileUtils.rm images
    end
  end
end
