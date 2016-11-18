class User < ApplicationRecord
  include RoleModel
  roles :admin
  roles_attribute :roles_mask
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :decks
  has_many :shares, :through => :decks
end
