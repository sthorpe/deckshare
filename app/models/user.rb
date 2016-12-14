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
  has_many :questions

  serialize(:raw_clearbit_data, JSON)

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
    user.refresh_token = access_token.credentials.refresh_token
    user.oauth_expires_at = Time.at(access_token.credentials.expires_at)
    user.save!

    if user
      user.save_google_contacts(user.oauth_token, max_results: '100', user_id: user.id, email: user.email)
      SaveGoogleContactsWorker.perform_async(user.id)
    end

    user
  end

  def token_update
    data = {
      :client_id => "850968458455-4atj8klv44clc52i7j4gdq6261lbavhh.apps.googleusercontent.com",
      :client_secret => "JlwdMr4mAJ2BHuXQR6AERDPK",
      :refresh_token => self.refresh_token,
      :grant_type => "refresh_token"
    }
    @response = ActiveSupport::JSON.decode(RestClient.post "https://accounts.google.com/o/oauth2/token", data)
    if @response["access_token"].present?
      self.oauth_token = @response["access_token"]
      save
    else
      puts "Error, no token with refresh #{self.oauth_token}"
    end
  rescue RestClient::BadRequest => e
    Bugsnag.notify("Bad request #{e}")
  rescue
    Bugsnag.notify("#{data} is invalid!")
  end

  def collect_google_analytics_websites
    @client = self.connect_google
    @service = @client.discovered_api('analytics', 'v3')
    @response = @client.execute(
      api_method: @service.management.profiles.list,
      parameters: {
        accountId: "~all",
        webPropertyId: "~all"
      }
    )
    return @response
  end

  def collect_google_analytics_website_views(accountId, webPropertyId)
    @client = self.connect_google
    @service = @client.discovered_api('analytics', 'v3')
    @response = @client.execute(
      api_method: @service.management.profiles.list,
      parameters: {
        accountId: accountId,
        webPropertyId: webPropertyId
      }
    )
    return @response
  end

  def connect_google
    @client = Google::APIClient.new(
      :application_name => 'dogo',
      :application_version => '1.0.0'
    )
    @client.authorization.access_token = self.oauth_token
    @client.authorization.refresh_token = self.refresh_token
    @client.authorization.client_id = "850968458455-4atj8klv44clc52i7j4gdq6261lbavhh.apps.googleusercontent.com"
    @client.authorization.client_secret = "JlwdMr4mAJ2BHuXQR6AERDPK"
    @client.authorization.refresh!
    return @client
  end

  def collect_information_from_clearbit
    if self.email
      #Clearbit.key = 'sk_8152ae059fd7e013e5291314295331f2'
      Clearbit.key = 'sk_57501e4b49ad381a7f8d12c1b180cdd5'
      @result = Clearbit::Enrichment.find(email: self.email, stream: true)
      self.raw_clearbit_data = @result
      update_user_fields_with_clearbit_data(@result)
      save
    end
  end

  def update_user_fields_with_clearbit_data(data)
    self.first_name = self.raw_clearbit_data["person"]["name"]["givenName"]
    self.last_name = self.raw_clearbit_data["person"]["name"]["familyName"]
    self.company = self.raw_clearbit_data["person"]["employment"]["name"]
    self.location = self.raw_clearbit_data["person"]["location"]
    self.avatar_url = self.raw_clearbit_data["person"]["gravatar"]["avatar"]
  end

  def save_google_contacts(access_token, opts={})
    # Build contacts
    contacts_json = JSON.parse(open("https://www.google.com/m8/feeds/contacts/#{opts[:email]}/full?access_token="+access_token+"&alt=json&max-results=#{opts[:max_results]}").read)

    if !contacts_json.empty?
      data = contacts_json["feed"]["entry"].collect{|p| { name: p["title"]["$t"], email: p["gd$email"][0] } if p["gd$email"].present? }
    end

    if data
      data.each do |contact|
        if contact.present? && contact[:email].present?
          unless Contact.where(email: contact[:email]["address"], user_id: opts[:user_id]).take
            contact = Contact.new(name: contact[:name], email: contact[:email]["address"], user_id: opts[:user_id])
            contact.save
          end
        end
      end
    end
  end
end
