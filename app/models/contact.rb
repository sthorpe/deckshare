class Contact < ApplicationRecord
  serialize(:raw_clearbit_data, JSON)
  belongs_to :user

  after_save :collect_information_on_contact

  def collect_information_on_contact
    if self.email
      Clearbit.key = 'sk_8152ae059fd7e013e5291314295331f2'
      @result = Clearbit::Enrichment.find(email: self.email, stream: true)
      self.raw_clearbit_data = @result
      save
    end
  end
end
