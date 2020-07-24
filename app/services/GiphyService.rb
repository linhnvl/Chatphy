class GiphyService
  def initialize q_string
    @q_string = q_string
    @giphy_token = ENV["GIPHY_TOKEN"]
  end

  def call!
    url = "https://api.giphy.com/v1/gifs/search?api_key=#{@giphy_token}&q=#{@q_string}&limit=1"
    response = HTTParty.get(url)
    data = response["data"][0]
    gif_id = data["id"]
    gif_url = data["images"]["downsized_large"]["url"]
    IO.copy_stream(open(gif_url), "./public/images/#{gif_id}.gif")
    gif_id
  end
end
