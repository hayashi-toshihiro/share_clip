class TagsController < ApplicationController
  skip_before_action :require_login, only: %i[index]
  require 'miyabi'
  require 'romaji'
  require 'romaji/core_ext/string'
  require 'levenshtein'

  def index
  end

  def auto_complete_streamers
    term = params[:term]
    # ローマ字変換
    term_romaji = to_roman(term)
    # それぞれのタグをローマ字変換して、条件で絞る
    matching_streamers_names = ClipPost.tags_on(:streamers)
                                .select do |tag|
                                  roman_name = to_roman(tag.name)
                                  matching_character_count(roman_name, term_romaji) >= 2 ||
                                    roman_name.include?(term_romaji)
                                end
                                .map(&:name)
  
    # オートコンプリートの候補としてnameを返す
    render json: matching_streamers_names
  end

  def auto_complete_tags
    term = params[:term].downcase

    matching_tags_names = ClipPost.tags_on(:tags).where('lower(name) LIKE ?', "%#{term}%").pluck(:name)

    # オートコンプリートの候補としてtitleを返す
    render json: matching_tags_names
  end

  def to_roman(text)
    text = text.downcase
    return text if text.include?('_')
    return text if text.is_roman?
    
    text.to_kanhira.romaji
  end

  def matching_character_count(str1, str2)
    # レーベンシュタイン距離で一致する文字数をカウント
    distance = Levenshtein.distance(str1, str2)
    max_length = [str1.length, str2.length].max
    matching_count = max_length - distance
  end
end
