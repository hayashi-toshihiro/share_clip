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
    # データ取得のリクエスト送信
    send_request(url)
  rescue RestClient::ExceptionWithResponse
    nil
  end

  def get_game_name(game_id)
    # Twitch APIのエンドポイント
    url = "https://api.twitch.tv/helix/games?id=#{game_id}"

    send_request(url)
  rescue RestClient::ExceptionWithResponse
    nil
  end

  def get_streamer_image(broadcaster_id)
    # Twitch APIのエンドポイント
    url = "https://api.twitch.tv/helix/users?id=#{broadcaster_id}"

    send_request(url)
  rescue RestClient::ExceptionWithResponse
    nil
  end

  def get_streamer_color(broadcaster_id)
    # Twitch APIのエンドポイント
    url = "https://api.twitch.tv/helix/chat/color?user_id=#{broadcaster_id}"

    send_request(url)
  rescue RestClient::ExceptionWithResponse
    nil
  end

  def get_stamp(broadcaster_id)
    # Twitch APIのエンドポイント
    url = "https://api.twitch.tv/helix/chat/emotes?broadcaster_id=#{broadcaster_id}"

    send_request(url)
  rescue RestClient::ExceptionWithResponse
    nil
  end

  def get_archive(broadcaster_id, clip_created_time)
    url = "https://api.twitch.tv/helix/videos?user_id=#{broadcaster_id}&period=month&type=archive"
    response = send_request(url)
    return nil unless response

    # created_atの配列を抽出
    created_at_times = extract_created_at_times(response)

    # clip_created_time以前の最も近いcreated_atを取得
    nearest_created_at = find_nearest_created_at(clip_created_time, created_at_times)
    # ビデオデータのIDを取得
    video_id = response['data'].find { |video| Time.zone.parse(video['created_at']) == nearest_created_at }.fetch('id')

    # クリップ作成時刻とビデオ作成時刻の差を秒単位で計算
    time_difference_seconds = calculate_time_difference_in_seconds(Time.zone.parse(clip_created_time), nearest_created_at)

    # video_dataとして、videoの内容とtime_defferenceを返す
    video_data = get_video(video_id)
    video_data["data"][0]["time_difference_seconds"] = time_difference_seconds
    video_data
  end

  # レスポンスからcreated_atの配列を作成するメソッド
  def extract_created_at_times(response)
    return [] unless response && response['data']

    response['data'].map { |video| Time.zone.parse(video['created_at']) }
  end

  # clip_created_timeから遡って一番近いcreated_atを取得するメソッド
  def find_nearest_created_at(clip_created_time, created_at_times)
    clip_time = Time.zone.parse(clip_created_time)
    created_at_times.select { |time| time <= clip_time }.max
  end

  def calculate_time_difference_in_seconds(clip_created_time, video_created_time)
    time_difference_seconds = (video_created_time - clip_created_time).to_i
    time_difference_seconds.abs - 65
  end

  def get_video(video_id)
    url = "https://api.twitch.tv/helix/videos?id=#{video_id}"

    send_request(url)
  rescue RestClient::ExceptionWithResponse
    nil
  end

  private

  def send_request(url)
    # ヘッダーの設定
    headers = {
      'Client-ID' => Rails.application.credentials.twitch_api[:client_id],
      'Authorization' => Rails.application.credentials.twitch_api[:authorization]
    }
    # GETリクエストの送信
    response = RestClient.get(url, headers)
    # レスポンスをJSON形式にパース
    JSON.parse(response.body)
  end
end
