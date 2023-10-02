class TagsController < ApplicationController
  skip_before_action :require_login, only: %i[index]

  def index
    streamers_name = ClipPost.tags_on(:streamers).pluck(:name)
    @streamers_image = Image.where(name: streamers_name).index_by(&:name)
    @games = Image.where(name: ClipPost.tags_on(:games).pluck(:name))
    @tags = ClipPost.tags_on(:tags)
  end
end
