class LikesController < ApplicationController
  def create
    @clip_post = ClipPost.find(params[:clip_post_id])
    current_user.like(@clip_post)
  end

  def destroy
    @clip_post = current_user.likes.find(params[:id]).clip_post
    current_user.unlike(@clip_post)
  end
end
