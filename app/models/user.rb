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
        user.oauth_token = access_token.credentials.token
        user.oauth_expires_at = Time.at(access_token.credentials.expires_at)
        user.save!
    end

    if user
      user.save_google_contacts(access_token)
    end

    user
  end

  def save_google_contacts(access_token)
    # Build contacts
    contacts_json = JSON.parse(open("https://www.google.com/m8/feeds/contacts/default/full?access_token="+access_token.credentials.token+"&alt=json").read)
    if contacts_json
      data = contacts_json["feed"]["entry"].collect{|p| { name: p["title"]["$t"], email: p["gd$email"][0] }}
    end

    if data
      data.each do |contact|
        unless Contact.find_by_email(contact[:email]["address"])
          contact = Contact.new(name: contact[:name], email: contact[:email]["address"], user_id: self.id)
          contact.save
        end
      end
    end
  end
end
