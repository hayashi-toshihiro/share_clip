require 'rest-client'
require 'json'
require 'uri'

class TwitchApi
  def get_clip(url)
    # urlからclip_idを取り出す。
    uri = URI.parse(url)
    clip_id = uri.path.split('/').last

    # Twitch APIのエンドポイント
    url = "https://api.twitch.tv/helix/clips?id=#{clip_id}"

    # ヘッダーを設定
    headers = {
      'Client-ID' => '11gshrju07m1wwgyqgpjrir3scixrl',
      'Authorization' => 'Bearer j0jjz62acp6manjs0pgiaa7a93haoi'
    }

    # GETリクエストを送信
    response = RestClient.get(url, headers)

    # レスポンスをJSON形式にパース
    JSON.parse(response.body)

    # レスポンスデータを返す
  rescue RestClient::ExceptionWithResponse
    nil
  end

  def get_game_name(game_id)
    # Twitch APIのエンドポイント
    url = "https://api.twitch.tv/helix/games?id=#{game_id}"

    # ヘッダーを設定
    headers = {
      'Client-ID' => '11gshrju07m1wwgyqgpjrir3scixrl',
      'Authorization' => 'Bearer j0jjz62acp6manjs0pgiaa7a93haoi'
    }

    # GETリクエストを送信
    response = RestClient.get(url, headers)

    # レスポンスをJSON形式にパース
    JSON.parse(response.body)

    # レスポンスデータを返す
  rescue RestClient::ExceptionWithResponse
    nil
  end

  def get_streamer_image(broadcaster_id)
    # Twitch APIのエンドポイント
    url = "https://api.twitch.tv/helix/users?id=#{broadcaster_id}"

    # ヘッダーを設定
    headers = {
      'Client-ID' => '11gshrju07m1wwgyqgpjrir3scixrl',
      'Authorization' => 'Bearer j0jjz62acp6manjs0pgiaa7a93haoi'
    }

    # GETリクエストを送信
    response = RestClient.get(url, headers)

    # レスポンスをJSON形式にパース
    JSON.parse(response.body)

    # レスポンスデータを返す
  rescue RestClient::ExceptionWithResponse
    nil
  end

  def get_streamer_color(broadcaster_id)
    # Twitch APIのエンドポイント
    url = "https://api.twitch.tv/helix/chat/color?user_id=#{broadcaster_id}"
    # ヘッダーを設定
    headers = {
      'Client-ID' => '11gshrju07m1wwgyqgpjrir3scixrl',
      'Authorization' => 'Bearer j0jjz62acp6manjs0pgiaa7a93haoi'
    }

    # GETリクエストを送信
    response = RestClient.get(url, headers)

    # レスポンスをJSON形式にパース
    JSON.parse(response.body)

    # レスポンスデータを返す
  rescue RestClient::ExceptionWithResponse
    nil
  end

  def get_stamp(broadcaster_id)
    # Twitch APIのエンドポイント
    url = "https://api.twitch.tv/helix/chat/emotes?broadcaster_id=#{broadcaster_id}"

    # ヘッダーを設定
    headers = {
      'Client-ID' => '11gshrju07m1wwgyqgpjrir3scixrl',
      'Authorization' => 'Bearer j0jjz62acp6manjs0pgiaa7a93haoi'
    }

    # GETリクエストを送信
    response = RestClient.get(url, headers)

    # レスポンスをJSON形式にパース
    JSON.parse(response.body)

    # レスポンスデータを返す
  rescue RestClient::ExceptionWithResponse
    nil
  end
end
