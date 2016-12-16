require "facebook/messenger"
class ContactsController < ApplicationController
  include Facebook::Messenger
  before_action :authenticate_user!
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = Contact.all
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def google
    @contacts = current_user.contacts
    @ga_portals = current_user.collect_google_analytics_websites.data.items
    @param = (0...8).map { (65 + rand(26)).chr }.join
    Facebook::Messenger::Subscriptions.subscribe
    Bot.on :message do |message|
      Bot.deliver(
        recipient: message.sender,
        message: {
          text: message.text
        }
      )
    end
    Bot.on :optin do |optin|
      Bot.deliver({recipient: {id: "WCNPLXJU"}, message: { text: 'Hello, world'}, access_token: 'EAADRoZCKkBjoBAAADzh8MzWYuI1tyQNrxYd81cDZCIHWWGWqUx1LGOBgyb880tPMdQWF1KZB3fVJMpMLbnWYgMos43EJRHxKDCistFxuBSYYDzd1IcR9q5lRzL6ZBcOfcJk3U4ZCZClVcDz4hKZBWPn5ZA58lDXCemiycRUV6tF1jgZDZD'})
    end
  end

  def send_message_to_fb_user

  end

  def google_analytics_website_stats
    user = User.where(id: params[:id])
    @stats = user.collect_google_analytics_website_views(params[:accountId], params[:webPropertyId])
    render :json => @stats
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:email, :user_id, :name)
    end
end
