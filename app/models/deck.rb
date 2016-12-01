
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

  def is_video?
    self.file_upload.content_type =~ %r(video)
  end

  def is_audio?
    self.file_upload.content_type =~ /\Aaudio\/.*\Z/
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
    is_audio?
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

  def build_slides
    if valid?
      # require 'RMagick'
      # pdf = Magick::ImageList.new("https:#{self.pdf_url}")
      # pdf.each_with_index do |page_img, i|
      #   page_img.write "#{i}_pdf_page.jpg"
      # end

      Paperclip.run('convert', "-quality #{Slide::QUALITY} -density #{Slide::DENSITY} #{get_pdf_from_aws.path} #{get_pdf_from_aws.path}%d.png")
      images = Dir.glob("#{get_pdf_from_aws.path}*.png").sort_by do |line|
        line.match(/(\d+)\.png$/)[1].to_i
      end

      images.each do |slide_image|
        slides.build(:image => File.open(slide_image))
      end
      FileUtils.rm images
    end
  end
end
