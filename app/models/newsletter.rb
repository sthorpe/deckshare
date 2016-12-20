class Newsletter < ApplicationRecord
  validates :email, confirmation: false
end
