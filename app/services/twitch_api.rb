require 'rest-client'
require 'json'
require 'uri'

class TwitchApi
  def get_clip(clip_id)
    # Twitch APIのエンドポイント
    url = "https://api.twitch.tv/helix/clips?id=#{clip_id}"
    
    # ヘッダーを設定
    headers = {
      'Client-ID' => '11gshrju07m1wwgyqgpjrir3scixrl',
      'Authorization' => 'Bearer j0jjz62acp6manjs0pgiaa7a93haoi'
    }
    
    # GETリクエストを送信
    response = RestClient.get(url,headers)
    
    # レスポンスをJSON形式にパース
    json_response = JSON.parse(response.body)
    
    # レスポンスデータを返す
    return json_response
  rescue RestClient::ExceptionWithResponse => e
    # エラーレスポンスを処理するコードを追加
    puts "APIエラー: #{e.response.code}"
    puts e.response.body
    return nil
  end
end

url = "https://www.twitch.tv/akamikarubi/clip/BumblingShinyEndiveVoHiYo-G4qhbaXZCTBN3WXp?featured=true&filter=clips&range=all&sort=time"
uri = URI.parse(url)
clip_id = uri.path.split('/').last
puts clip_id
a = TwitchApi.new
puts a.get_clip(clip_id)