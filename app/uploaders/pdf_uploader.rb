# encoding: utf-8

class PdfUploader < CarrierWave::Uploader::Base
  include CarrierWaveDirect::Uploader

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  #storage :file
  #storage :fog
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  # def store_dir
  #   "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  # end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    # For Rails 3.1+ asset pipeline compatibility:
    # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))

    #{}"/images/fallback/" + [version_name, "default.png"].compact.join('_')
    'homer.png' #rails will look at 'app/assets/images/default_avatar.png'
  end

  #process :convert_to_text
  #process :build_slides

  def build_slides
    Deck.build_slides(original_filename) if original_filename.present?
  end

  def convert_to_text
    temp_dir = Rails.root.join('tmp', 'pdf-parser', 'text')
    temp_path = temp_dir.join(filename)

    FileUtils.mkdir_p(temp_dir)

    PDF::Reader.open(current_path) do |pdf|
      File.open(temp_path, 'w') do |f|
        pdf.pages.each do |page|
          f.puts page.text
        end
      end
    end

    File.unlink(current_path)
    FileUtils.cp(temp_path, current_path)
  end

  def filename
    super + '.txt' if original_filename.present?
  end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :large do
  #   # returns a 150x150 image
  #   process :resize_to_fill => [150, 150]
  # end
  # version :medium do
  #   # returns a 50x50 image
  #   process :resize_to_fill => [50, 50]
  # end
  # version :small do
  #   # returns a 35x35 image
  #   process :resize_to_fill => [35, 35]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(pdf doc htm html docx)
  end

end
