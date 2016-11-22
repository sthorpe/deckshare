class MessagesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  def index
    @messages = Message.all
  end

  def show
    @message = Message.find(params[:id])
  end

  def create
    @message = Message.create(message_params)
    @current_user = current_user
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def message_params
      params.require(:message).permit(:user_id, :deck_id, :content)
    end
end
