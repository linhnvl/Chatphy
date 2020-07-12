require "open-uri"                                                                      

class HooksController < ApplicationController
  before_action :filter_params

  def create
    ChatWork.api_key = ENV["CW_TOKEN"]

    message_data = ChatWork::Message.find(room_id: @room_id, message_id: @message_id)
    from_account_name = message_data.account.name

    gif_id = GiphyService.new(@q_string).call!
    file = Faraday::UploadIO.new("public/images/#{gif_id}.gif", "image/gif")
    message = "[rp aid=#{@from_id} to=#{@room_id}-#{@message_id}]#{from_account_name}"

    ChatWork::File.create(room_id: @room_id, file: file, message: message)
  end

  private
  def filter_params
    cw_params = params[:webhook_event]
    @from_id = cw_params[:from_account_id]
    @q_string = cw_params[:body].split("\n").last
    @room_id = cw_params[:room_id]
    @message_id = cw_params[:message_id]
  end
end
