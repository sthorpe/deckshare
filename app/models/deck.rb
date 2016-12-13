
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
  #mount_uploader :pdf, PdfUploader
  belongs_to :user
  has_many :shares
  has_many :messages
  has_many :slides, :dependent => :destroy

  serialize(:data, JSON)

  def is_image?
    self.file_upload.content_type =~ %r(image)
  end

  def is_plain_text?
    self.file_upload_file_name =~ %r{\.(txt)$}i
  end

  def is_excel?
    self.file_upload_file_name =~ %r{\.(xls|xlt|xla|xlsx|xlsm|xltx|xltm|xlsb|xlam|csv|tsv)$}i
  end

  def is_word_document?
    self.file_upload_file_name =~ %r{\.(docx|doc|dotx|docm|dotm)$}i
  end

  def is_powerpoint?
    self.file_upload_file_name =~ %r{\.(pptx|ppt|potx|pot|ppsx|pps|pptm|potm|ppsm|ppam)$}i
  end

  def is_pdf?
    self.file_upload_file_name =~ %r{\.(pdf)$}i
  end

  def has_default_image?
    is_plain_text?
    is_excel?
    is_word_document?
  end

  def get_pdf_from_aws
    require 'open-uri'
    download = open("https:#{self.pdf_url}")
    return download
    #IO.copy_stream(download, '~/image.png')
  end

  def make_image
    file = File.join(Dir.tmpdir, "#{self.id}_image.png")
    `convert -background lightblue -fill blue -font Arial -pointsize 72 label:some-text #{file}`
    io = File.read(file)
    self.image = io
  end

  def build_slides
    if valid?
      begin
        Magick::ImageList.new("http:#{self.pdf_url}") do
          self.quality = 100
          self.density = 144
          self.colorspace = Magick::RGBColorspace
          self.interlace = Magick::NoInterlace
        end.each_with_index do |page_img, i|
          page_img.resize_to_fit!(2574, 1930)
          page_img.write "#{Rails.root}/tmp/#{i}_pdf_page.jpg"
          slides.build(:image =>  File.new("#{Rails.root}/tmp/#{i}_pdf_page.jpg"))
          FileUtils.rm "#{Rails.root}/tmp/#{i}_pdf_page.jpg"
        end
      rescue => exception
        Bugsnag.notify(exception)
      end
      save
    end
  end
end
