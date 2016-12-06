class User < ApplicationRecord
  include RoleModel
  roles :admin
  roles_attribute :roles_mask
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :omniauthable, :omniauth_providers => [:google_oauth2]
  has_many :decks
  has_many :shares, :through => :decks
  has_many :contacts

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(:email => data["email"]).first

    unless user
      user = User.create(name: data["name"],
         email: data["email"],
         password: Devise.friendly_token[0,20]
      )
      user.provider = access_token.provider
      user.uid = access_token.uid
      user.name = access_token.info.name
    end

    user.oauth_token = access_token.credentials.token
    user.oauth_expires_at = Time.at(access_token.credentials.expires_at)
    user.save!

    if user
      user.save_google_contacts(access_token)
    end

    user
  end

  def save_google_contacts(access_token)
    # Build contacts
    contacts_json = JSON.parse(open("https://www.google.com/m8/feeds/contacts/#{self.email}/full?access_token="+access_token.credentials.token+"&alt=json&max-results=1000").read)

    if !contacts_json.empty?
      data = contacts_json["feed"]["entry"].collect{|p| { name: p["title"]["$t"], email: p["gd$email"][0] } if p["gd$email"].present? }
    end

    if data
      data.each do |contact|
        if contact.present? && contact[:email].present?
          unless Contact.find_by_email(contact[:email]["address"])
            contact = Contact.new(name: contact[:name], email: contact[:email]["address"], user_id: self.id)
            contact.save
          end
        end
      end
    end
  end
end
