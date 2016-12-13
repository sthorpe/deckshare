class Contact < ApplicationRecord
  serialize(:raw_clearbit_data, JSON)
  belongs_to :user

  def collect_information_on_contact
    if self.email
      #Clearbit.key = 'sk_8152ae059fd7e013e5291314295331f2'
      Clearbit.key = 'sk_57501e4b49ad381a7f8d12c1b180cdd5'
      @result = Clearbit::Enrichment.find(email: self.email, stream: true)
      self.raw_clearbit_data = @result
      save
    end
  end
end
