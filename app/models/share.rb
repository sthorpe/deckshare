class Share < ApplicationRecord
  belongs_to :deck
  before_save :generate_url_code


  protected
    def generate_url_code
      self.url = (0...8).map { (65 + rand(26)).chr }.join
    end
end
