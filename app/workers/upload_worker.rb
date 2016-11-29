class UploadWorker
  include Sidekiq::Worker

  def perform(document)
    Paperclip.run('convert', "-quality #{Slide::QUALITY} -density #{Slide::DENSITY} #{document.queued_for_write[:original].path} #{document.queued_for_write[:original].path}%d.png")
    images = Dir.glob("#{document.queued_for_write[:original].path}*.png").sort_by do |line|
      line.match(/(\d+)\.png$/)[1].to_i
    end

    images.each do |slide_image|
      slides.build(:image => File.open(slide_image))
    end
    FileUtils.rm images
  end
end
