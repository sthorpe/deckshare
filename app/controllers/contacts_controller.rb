class ContactsController < ApplicationController
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
    # Clearbit.key = 'sk_8152ae059fd7e013e5291314295331f2'
    # @enrichment = Clearbit::Enrichment.find(email: 'scott@mogotix.com', stream: true)
    # @discovery = Clearbit::Discovery.search(query: {tech: 'marketo', raised: '100000~'}, sort: 'alexa_asc')
    # @prospector = Clearbit::Prospector.search(domain: 'twitter.com', role: 'marketing')
    # @reveal = Clearbit::Reveal.find(ip: '73.70.233.1')
  end

  def google_analytics_website_stats
    user = User.where(id: params[:id])
    @stats = user.collect_google_analytics_website_views(params[:accountId], params[:webPropertyId])
    @param = (0...8).map { (65 + rand(26)).chr }.join
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
